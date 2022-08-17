class UpdateBacklinksJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.backlink
  end
end
