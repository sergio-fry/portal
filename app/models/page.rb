class Page < ApplicationRecord
  before_save :update_backlinks
  after_save :sync_linked_pages

  has_many :links
  has_many :back_links, foreign_key: :target_page_id, class_name: "Link", autosave: true

  has_many :linked_pages, through: :back_links, source: :page, class_name: "Page"
  has_many :linking_to_pages, through: :links, source: :target_page, class_name: "Page"

  validates :slug, format: {with: /\A[a-zа-я0-9\-_]+\z/}, uniqueness: true, presence: true

  def to_param
    slug
  end

  def processed_content(ipfs: false)
    ProcessedContent.new(self, ipfs:)
  end

  def ipfs_content
    if changed?
      ipfs_new_content
    else
      ipfs_cid.present? ? Ipfs::Content.new(ipfs_cid) : ipfs_new_content
    end
  end

  def ipfs_new_content
    Ipfs::NewContent.new(
      Layout.new(
        processed_content(ipfs: true).to_s,
        self
      ).to_s
    )
  end

  def sync_to_ipfs
    self.ipfs_cid = ipfs_new_content.cid
    PingJob.perform_later(ipfs_new_content.url) if ENV.fetch("IPFS_PING_ENABLED", "false") == "true"
  end

  def content=(value)
    super

    return unless content_changed?

    add_new_links
    links.destroy removed_links
    sync_to_ipfs
    track_history
  end

  def track_history
    # page_versions.build ipfs_cid: ipfs_cid
  end

  def removed_links
    links.reject { |link| active_links.map(&:page).include?(link.target_page) }
  end

  def new_links
    active_links.reject { |link| links.map(&:target_page).include? link.page }
  end

  def active_links
    processed_content.page_links.find_all(&:target_exists?)
  end

  private

  def add_new_links
    links.build(
      new_links.map { |link|
        {
          page: self,
          target_page: link.page,
          slug: link.page.slug
        }
      }
    )
  end

  def update_backlinks
    return unless slug_changed?

    back_links.each do |link|
      link.slug = slug
    end
  end

  def sync_linked_pages
    linked_pages.each { |page| ExportPageToIpfsJob.perform_later(page) }
  end
end
