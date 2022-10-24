# frozen_string_literal: true

module Boundaries
  module Database
    class Link < ApplicationRecord
      self.table_name = "page_links"

      after_save :refresh_back_link, if: :slug_previously_changed?

      belongs_to :page
      belongs_to :target_page, class_name: "Page"
      validates :slug, presence: true

      def refresh_back_link
        ::Page.new(page.slug).processed_content.page_links.find_all { |link| link.slug == slug_previously_was }.each do |link|
          page.content = page.content.gsub link.markup, link.moved_to(slug).markup
        end
        page.save!
      end
    end
  end
end
