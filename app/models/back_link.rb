class BackLink < ApplicationRecord
  self.table_name = "page_links"

  belongs_to :page, foreign_key: :target_page_id
  belongs_to :source_page, class_name: "Page", foreign_key: :page_id
end
