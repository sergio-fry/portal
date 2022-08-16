class Page < ApplicationRecord
  before_save { export_to_ipfs }

  def to_param
    title
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

  def export_to_ipfs
    new_cid = ipfs_new_content.cid
    update_column(:ipfs_cid, new_cid) if ipfs_cid != new_cid
  end
end
