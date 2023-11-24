module Platform85
  module Repo
    class DynamicCollection
      include Enumerable

      def initialize(&block)
        @block = block
      end

      def each(&)
        cached_items.each(&)
      end

      def size = entries.size

      def cached_items = @cached_items ||= @block.call
    end
  end
end
