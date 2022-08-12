class ExportPageToIpfsJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.export_to_ipfs
  end
end