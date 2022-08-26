require "http"
require_relative "gateway"
require_relative "content"

module Ipfs
  class Folder
    def initialize(cid, gateway: Gateway.new)
      @cid = cid
      @gateway = gateway
    end

    def dag
      cid_v1 = @gateway.cid_format(@cid, v: 1)
      @gateway.dag_get(cid_v1)
    end

    def file(path)
      Content.new(
        dag["Links"].find do |link|
          link["Name"] == path
        end.dig("Hash", "/")
      )
    end
  end
end
