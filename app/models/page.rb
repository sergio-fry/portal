class Page < ApplicationRecord
  after_save { sync_to_ipfs }

  has_many :links
  has_many :back_links, foreign_key: :target_page_id, class_name: "Link"

  has_many :linked_pages, through: :back_links, source: :page, class_name: "Page"
  has_and_belongs_to_many :linking_to_pages, class_name: "Page", join_table: :page_links, foreign_key: :page_id, association_foreign_key: :target_page_id

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
    self.linking_to_page_ids = processed_content.page_links.map(&:page).compact.map(&:id)
  end
end
