require_relative "./folder"

module Ipfs
  class NewFolder
    def initialize(content_map)
      @content_map = content_map
    end

    def content_at(path)
      Folder.new(cid).content_at(path)
    end

    def cid
      "QmcsCTDSikyASmX6j4wvnMKaU9vt3esQwvXb9ZupAVuD1T"
    end
  end
end
