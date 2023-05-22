# frozen_string_literal: true

class RebuildPageJob < ApplicationJob
  queue_as :default

  def perform(page_slug)
    Page.new(page_slug).tap do |page|
      page.update_links
      page.sync_to_ipfs
      page.track_history
    end
  end
end
