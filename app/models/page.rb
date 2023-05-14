# frozen_string_literal: true

require_relative './processed_content'

class Page
  attr_reader :slug

  def initialize(slug)
    @slug = slug
  end

  alias title slug

  def ==(other) = other.slug.to_s == slug.to_s

  def move(new_slug)
    @slug_before_moving = @slug
    record.tap do |page|
      page.slug = new_slug
      page.save!
    end
    @slug = new_slug
    update_backlinks new_slug
  end

  def source_content = record.content.to_s

  def source_content=(new_content)
    record.tap do |page|
      page.content = new_content
      page.save!
    end

    update_links

    # TODO
    # sync_to_ipfs
    # track_history
  end

  def history = PageHistory.new self
  def history_ipfs_content = Ipfs::NewContent.new(history.to_s)

  def track_history
    versions.build(ipfs_cid:)
    self.history_ipfs_cid = Ipfs::NewContent.new(history.to_s).cid
  end

  def content = processed_content.to_s

  def processed_content = ProcessedContent.new(source_content)

  def exists? = content != ''

  # def ipfs
  # def history
  # def incoming_links
  # def outgoing_links

  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  def ipfs
    Ipfs::NewContent.new(
      processed_content_with_layout
    )
  end

  def sync_to_ipfs
    self.ipfs_cid = ipfs.cid
  end

  def update_backlinks(new_slug)
    back_links.each do |link|
      link.refresh
    end
  end

  def back_links
    record.back_links.map { |record| Link.new(page: Page.new(record.page.slug), target_page: self) }
  end

  def updated_at
    record.updated_at || Time.zone.now
  end

  def versions
    record.versions || []
  end

  def linked_pages
    record.linked_pages.map { |rec| self.class.new(rec.slug) }
  end

  def record
    Boundaries::Database::Page.find_or_initialize_by(slug: @slug)
  end

  private

  def update_links
    # TODO: use Link model (not boundaries AR)
    active_links = processed_content.page_links.find_all(&:target_exists?)
    same_links = record.links.find_all { |rec| active_links.map(&:slug).include? rec.slug }
    new_links = active_links.reject { |link| same_links.map(&:slug).include? link.slug }.map do |link|
      record.links.build(slug: link.slug, target_page: link.page.record)
    end

    record.tap do |record|
      record.links = same_links + new_links
      record.save!
    end
  end
end
