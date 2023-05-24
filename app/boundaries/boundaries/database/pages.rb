# frozen_string_literal: true

module Boundaries
  module Database
    class Pages
      def create(attrs) = Page.create!(attrs)
      def exists?(slug) = Page.exists?(slug:)
      def find(id) = Page.find id
      def find_by_slug(slug) = Page.find_by(slug:)
      def find_or_initialize_by_slug(slug) = Page.find_or_initialize_by(slug:)
      def updated_at = Page.maximum(:updated_at)

      def each
        Page.select(:id, :slug).find_each do |record|
          yield ::Page.new(record.slug)
        end
      end
    end
  end
end
