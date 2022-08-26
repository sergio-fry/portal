require_relative "gateway"

module Ipfs
  class Content
    attr_reader :cid

    def initialize(cid, gateway: Gateway.new)
      @cid = cid
      @gateway = gateway
    end

    def url(filename: nil)
      result = ""
      result += "https://ipfs.io/ipfs/#{@cid}"
      result = [result, URI.encode_www_form({filename: filename})].join("?") unless filename.nil?

      result
    end

    def data
      @gateway.cat @cid
    end
  end
end
