# frozen_string_literal: true

module Boundaries
  module Ipfs
    class NewContent
      attr_reader :data

      include Dependencies['ipfs.gateway']

      def initialize(data, gateway:)
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
end
