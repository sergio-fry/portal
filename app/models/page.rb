class Page < ApplicationRecord
  after_save { sync_to_ipfs }

  has_many :links
  has_many :back_links, foreign_key: :target_page_id, class_name: "Link"

  has_many :linked_pages, through: :back_links, source: :page, class_name: "Page"
  has_many :linking_to_pages, through: :links, source: :target_page, class_name: "Page"

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
    if ipfs_cid != ipfs_new_content.cid
      update_column :ipfs_cid, ipfs_new_content.cid
      PingJob.perform_later(ipfs_new_content.url) if ENV.fetch("IPFS_PING_ENABLED", "false") == "true"
      linked_pages.each(&:sync_to_ipfs)
    end
  end

  def content=(value)
    super

    add_new_links
    links.destroy removed_links
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
          target_page: link.page
        }
      }
    )
  end
end
