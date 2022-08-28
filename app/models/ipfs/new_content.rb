require_relative "./gateway"

module Ipfs
  class NewContent
    attr_reader :data

    def initialize(data, gateway: Gateway.new)
      @data = data

      @gateway = gateway
    end

    def cid
      result = @gateway.add @data
      PingJob.perform_later(url) if ENV.fetch("IPFS_PING_ENABLED", "false") == "true"

      result
    end

    def content
      Content.new(cid)
    end

    def url(*args)
      content.url(*args)
    end
  end
end
