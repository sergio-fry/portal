module Ipfs
  class Content
    attr_reader :cid

    def initialize(cid)
      @cid = cid
    end

    def url(filename: nil)
      result = ""
      result += "https://ipfs.io/ipfs/#{@cid}"
      result = [result, URI.encode_www_form({filename: filename})].join("?") unless filename.nil?

      result
    end

    def data
      raise "not implemented"
    end
  end
end
