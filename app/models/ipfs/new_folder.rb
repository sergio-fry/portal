# frozen_string_literal: true

require_relative './folder'
require_relative './gateway'

module Ipfs
  class NewFolder
    def initialize(files_map: {}, gateway: Gateway.new)
      @files_map = files_map
      @gateway = gateway
    end

    def with_file(path, content)
      self.class.new(
        files_map: @files_map.merge(path => content),
        gateway: @gateway
      )
    end

    def file(path)
      folder.file(path)
    end

    def cid
      cid_v1 = @gateway.dag_put dag

      @gateway.cid_format cid_v1, v: 0
    end

    def folder
      Folder.new(cid)
    end

    def url(*args)
      folder.url(*args)
    end

    def dag
      {
        Data: {
          "/": {
            bytes: 'CAE'
          }
        },
        Links: @files_map.map do |path, content|
          {
            Hash: {
              "/": content.cid
            },
            Name: path,
            Tsize: 14
          }
        end
      }.to_json
    end
  end
end
