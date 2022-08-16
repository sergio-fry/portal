class ExportPageToIpfsJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.sync_to_ipfs
    page.save!
  end
end
