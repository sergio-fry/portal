class Link < ApplicationRecord
  self.table_name = "page_links"

  belongs_to :page, autosave: true
  belongs_to :target_page, class_name: "Page"
  validates :slug, presence: true

  def slug=(value)
    super

    page.processed_content.page_links.find_all { |link| link.slug == slug_was }.each do |link|
      page.content = page.content.gsub link.markup, link.moved_to(slug).markup
    end
  end
end
