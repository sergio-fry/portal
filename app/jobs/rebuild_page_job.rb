# frozen_string_literal: true

class RebuildPageJob < ApplicationJob
  queue_as :default

  def perform(page_slug)
    pages.find_aggregate(page_slug).tap do |page|
      pages.save_aggregate page
    end
  end

  def pages = DependenciesContainer.resolve(:pages)
end
