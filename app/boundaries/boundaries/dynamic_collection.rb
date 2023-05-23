# frozen_string_literal: true

module Boundaries
  class DynamicCollection
    include Enumerable

    def initialize(&block)
      @block = block
    end

    def each
      @block.call.each do |item|
        yield item
      end
    end
  end
end
