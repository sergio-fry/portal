# frozen_string_literal: true

require 'digest'

module Fake
  module Ipfs
    class Gateway
      def initialize
        @storage = {}
      end

      def add(content)
        @storage[cid(content)] = content

        cid(content)
      end

      def cid(content)
        Digest::SHA1.hexdigest content
      end

      def dag_put(dag)
        add dag.to_json
      end

      def dag_get(cid)
        JSON.parse cat(cid)
      end

      def cid_format(cid, ver:) # rubocop:disable Lint/UnusedMethodArgument
        # no conversion
        cid
      end

      def cat(cid)
        @storage[cid]
      end
    end
  end
end
