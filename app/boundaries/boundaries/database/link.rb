# frozen_string_literal: true

module Boundaries
  module Database
    class Link < ApplicationRecord
      self.table_name = 'page_links'

      belongs_to :page
      belongs_to :target_page, class_name: 'Page'
      validates :slug, presence: true
    end
  end
end
