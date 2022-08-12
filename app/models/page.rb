class Page < ApplicationRecord
  after_commit { ExportPageToIpfsJob.perform_later self }

  def to_param
    title
  end

  def processed_content(ipfs: false)
    ProcessedContent.new(self, ipfs:)
  end

  def ipfs
    IpfsFile.new(processed_content(ipfs: true))
  end

  def export_to_ipfs
    update_column(:ipfs_cid, ipfs.cid) if ipfs_cid != ipfs.cid
  end
end
