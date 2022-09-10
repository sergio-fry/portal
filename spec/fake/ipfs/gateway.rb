require "digest"

module Fake
  module Ipfs
    class Gateway
      def initialize
        @storage = {}
      end

      def add(content)
        @storage[cid(content)] = content
      end

      def cid(content)
        Digest::SHA1.hexdigest content
      end

      def dag_put(dag)

      end
    end
  end
end
