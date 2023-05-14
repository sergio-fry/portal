class Link
  def initialize(page:, target_page:)
    @page = page
    @target_page = target_page
  end

  def refresh
    slug_was = record.slug
    record.tap do |record|
      record.slug = @target_page.slug
      record.save!
    end
    refresh_link_code(slug_was)
  end

  def refresh_link_code(slug_was)
    @page.processed_content.page_links.find_all do |link|
      link.slug == slug_was
    end.each do |link|
      @page.source_content = @page.source_content.gsub link.markup, link.moved_to(slug).markup
    end
  end

  def slug = @target_page.slug

  def record
    Boundaries::Database::Link.find_or_initialize_by(page: @page.record, target_page: @target_page.record)
  end
end
