# frozen_string_literal: true

module Boundaries
  module Database
    class Pages
      def create(attrs) = Page.create!(attrs)
      def exists?(slug) = Page.exists?(slug:)
      def find(id) = Page.find id
      def find_by_slug(slug) = Page.find_by(slug:)
      def find_or_initialize_by_slug(slug) = Page.find_or_initialize_by(slug:)
      def find_by_slug(slug) = Page.find_by!(slug:)
      def updated_at = Page.maximum(:updated_at)
      def linked_pages(id) = Page.find(id).linked_pages
      def referenced_pages(id) = Page.find(id).linking_to_pages

      def each(&) = Page.find_each(&)

      def transaction(&) = ApplicationRecord.transaction(&)
    end
  end
end
