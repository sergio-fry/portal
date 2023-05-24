# frozen_string_literal: true

require_relative './processed_content'

class Page
  include Dependencies[db: 'db.pages', pages: 'pages', ipfs: 'ipfs.ipfs']

  attr_reader :slug, :history

  def initialize(slug, pages:, db:, history: PageHistory.new(self), ipfs:)
    @slug = slug
    @pages = pages
    @db = db
    @history = history
    @ipfs = ipfs
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
    update_backlinks
  end

  def source_content = record.content.to_s

  def source_content=(new_content)
    record.transaction do
      record.tap do |page|
        page.content = new_content
        page.save!
      end

      update_links
      sync_to_ipfs
      track_history
    end
  end

  def track_history = history.track

  def content = processed_content.to_s

  def processed_content = ProcessedContent.new(source_content)

  def exists? = content != ''

  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  def ipfs_content = record.ipfs_cid.present? ? ipfs.content(record.ipfs_cid) : new_ipfs_content
  def new_ipfs_content = ipfs.new_content(processed_content_with_layout)

  def sync_to_ipfs
    record.update! ipfs_cid: new_ipfs_content.cid
  end

  def update_backlinks = back_links.each(&:refresh)

  def back_links
    record.back_links.map { |record| Link.new(page: Page.new(record.page.slug), target_page: self) }
  end

  def updated_at = record.updated_at || Time.zone.now

  # TODO: do not autocreate. Otherwise anybody can create any page by typing sny URL
  # TODO: do not refer record directly from model
  def record = @record ||= @db.find_or_initialize_by_slug(@slug)

  def links = processed_content.page_links

  def update_links = pages.update_links(self)
end
