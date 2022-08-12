module Ipfs
  class Content
    def initialize(cid)
      @cid = cid
    end

    def url(filename: nil, only_path: false)
      result = ""
      result += "https://ipfs.io" unless only_path
      result += "/ipfs/#{@cid}"
      result = [result, URI.encode_www_form({filename: filename})].join("?") unless filename.nil?

      result
    end

    def data
      raise "not implemented"
    end
  end
end
