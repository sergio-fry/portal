# frozen_string_literal: true

module Boundaries
  class DynamicCollection
    include Enumerable

    def initialize(&block)
      @block = block
    end

    def each
      cached_items.each do |item|
        yield item
      end
    end

    def cached_items = @cached_items ||= @block.call
  end
end
