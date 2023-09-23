# frozen_string_literal: true

class PageAggregate
  attr_reader :id, :slug, :updated_at, :history, :source_content, :linked_pages, :referenced_pages

  include Dependencies[:pages]

  def initialize(
    id:,
    pages:,
    slug:,
    updated_at:,

    history: PageHistory.new(self),
    linked_pages: pages.linked_pages(self),
    referenced_pages: pages.referenced_pages(self),
    source_content: ''
  )
    @id = id
    @pages = pages
    @slug = slug
    @updated_at = updated_at

    @history = history
    @linked_pages = linked_pages
    @referenced_pages = referenced_pages
    @source_content = source_content
  end

  def exists? = @id.present?
  alias title slug
  def ==(other) = other.slug.to_s == slug.to_s || other.id == id

  def processed_content = ProcessedContent.new(@source_content)

  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  # TODO: extract Content class, content.source, content.processed
  def content = processed_content.to_s

  def slug=(new_slug)
    return if @slug == new_slug

    @linked_pages.each do |page|
      page.change_link_slug(@slug, new_slug)
    end
    @slug = new_slug
  end

  def source_content=(new_value)
    @source_content = new_value
    update_referenced_pages
  end

  def update_referenced_pages = @referenced_pages = processed_content.page_links.map(&:target_page).compact

  def change_link_slug(old_slug, new_slug)
    processed_content.page_links.find_all do |link|
      link.slug == old_slug
    end.each do |link|
      self.source_content = source_content.gsub link.markup, link.moved_to(new_slug).markup
    end
  end
end
