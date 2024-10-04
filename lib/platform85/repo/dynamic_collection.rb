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

      delegate :size, to: :entries

      def cached_items = @cached_items ||= @block.call
    end
  end
end
