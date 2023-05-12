# frozen_string_literal: true

module Ipfs
  class NewContent
    attr_reader :data

    def initialize(data)
      @data = data

      @gateway = DependenciesContainer.resolve('ipfs')
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
