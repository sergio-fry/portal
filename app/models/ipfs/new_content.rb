require_relative "./gateway"

module Ipfs
  class NewContent
    attr_reader :data

    def initialize(data, gateway: Gateway.new)
      @data = data

      @gateway = gateway
    end

    def cid
      @gateway.add @data
    end

    def content
      Content.new(cid)
    end

    def url(*args)
      content.url(*args)
    end
  end
end
