class Page < ApplicationRecord
  after_commit { ExportPageToIpfsJob.perform_later self }

  def to_param
    title
  end

  def processed_content
    ProcessedContent.new(self)
  end

  def ipfs
    IpfsFile.new(processed_content, cid: ipfs_cid)
  end

  def export_to_ipfs
    update_column :ipfs_cid, ipfs.cid
  end
end
