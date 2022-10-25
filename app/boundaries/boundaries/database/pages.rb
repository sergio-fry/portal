# frozen_string_literal: true

module Boundaries
  module Database
    class Pages
      def find_by_slug(slug)
        raise "Not found page with slug '#{slug}'" unless exists?(slug)

        ::Page.new slug
      end

      def exists?(slug)
        Page.where(slug: slug).exists?
      end

      def each(&block)
        Page.select(:id, :slug).find_each do |record|
          yield ::Page.new(record.slug)
        end
      end

      def updated_at
        Page.maximum(:updated_at)
      end
    end
  end
end
