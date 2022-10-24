# frozen_string_literal: true

module Boundaries
  module Database
    class Pages
      def find_by_slug(slug)
        ::Page.new slug
      end

      def each(&block)
        Page.select(:slug).find_each do |record|
          yield ::Page.new(record.slug)
        end
      end

      def updated_at
        Page.maximum(:updated_at)
      end
    end
  end
end
