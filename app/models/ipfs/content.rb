# frozen_string_literal: true

require_relative 'gateway'

module Ipfs
  class Content
    attr_reader :cid

    def initialize(cid)
      @cid = cid
      @gateway = DependenciesContainer.resolve(:ipfs)
    end

    def url(filename: nil)
      result = ''
      result += "#{ENV.fetch('IPFS_PUBLIC_GATEWAY_URL', 'https://ipfs.io/ipfs/')}#{@cid}"
      result = [result, URI.encode_www_form({ filename: })].join('?') unless filename.nil?

      result
    end

    def data
      @gateway.cat @cid
    end
  end
end
