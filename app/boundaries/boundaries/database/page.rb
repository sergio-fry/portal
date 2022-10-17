# frozen_string_literal: true

module Boundaries
  module Database
    class Page < ApplicationRecord
      has_many :back_links, foreign_key: :target_page_id, class_name: "Link", autosave: true
      has_many :linked_pages, through: :back_links, source: :page, class_name: "Page"
      has_many :linking_to_pages, through: :links, source: :target_page, class_name: "Page"
      has_many :links
      has_many :versions, class_name: "Boundaries::Database::PageVersion", autosave: true

      validates :slug, format: {with: /\A[a-zа-я0-9\-_]+\z/}, uniqueness: true, presence: true
      validates :content, presence: true
    end
  end
end
