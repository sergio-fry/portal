class Link < ApplicationRecord
  self.table_name = "page_links"

  belongs_to :page
  belongs_to :target_page, class_name: "Page"
end
