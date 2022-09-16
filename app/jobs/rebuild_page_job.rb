class RebuildPageJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.sync_to_ipfs
    page.history_ipfs_cid = Ipfs::NewContent.new(page.history.to_s).cid
    page.save!
  end
end
