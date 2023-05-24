# frozen_string_literal: true

module Boundaries
  module Database
    class Pages
      def create(attrs)
        Page.create! attrs
      end

      def find_by_slug(slug)
        Page.find_or_initialize_by slug:
      end

      def find_or_initialize_by_slug(slug)
        Page.find_or_initialize_by slug:
      end

      def exists?(slug)
        Page.exists?(slug:)
      end

      def each
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
