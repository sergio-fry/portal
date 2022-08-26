require_relative "./folder"
require_relative "./gateway"

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
      Folder.new(cid).file(path)
    end

    def cid
      cid_v1 = @gateway.dag_put dag

      @gateway.cid_format cid_v1, v: 0
    end

    def dag
      {
        Data: {
          "/": {
            bytes: "CAE"
          }
        },
        Links: @files_map.map { |path, content|
          {
            Hash: {
              "/": content.cid
            },
            Name: path,
            Tsize: 14
          }
        }
      }.to_json
    end
  end
end
