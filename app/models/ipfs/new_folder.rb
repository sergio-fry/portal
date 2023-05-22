# frozen_string_literal: true

require_relative './folder'

module Ipfs
  class NewFolder
    def initialize(files_map: {})
      @files_map = files_map
      @gateway = DependenciesContainer.resolve('ipfs')
    end

    def with_file(path, content)
      self.class.new(
        files_map: @files_map.merge(path => content)
      )
    end

    def file(*args) = folder.file(*args)

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
          '/': {
            bytes: 'CAE'
          }
        },
        Links: @files_map.map do |path, content|
          {
            Hash: {
              '/': content.cid
            },
            Name: path,
            Tsize: 14
          }
        end
      }
    end
  end
end
