class Page < ApplicationRecord
  after_commit { ExportPageToIpfsJob.perform_later self }

  def to_param
    title
  end

  def processed_content(ipfs: false)
    ProcessedContent.new(self, ipfs:)
  end

  def ipfs_content
    Ipfs::NewContent.new(
      Layout.new(
        processed_content(ipfs: true).to_s, 
        self
      ).to_s
    )
  end

  def export_to_ipfs
    new_cid = ipfs_content.cid
    update_column(:ipfs_cid, new_cid) if ipfs_cid != new_cid
  end
end
