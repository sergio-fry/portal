# frozen_string_literal: true

class CanonicalLink
  def initialize(slug)
    @slug = slug
  end

  def link = "#{ENV.fetch('ROOT_URL')}/pages/#{@slug}"

  def edit_link = "#{link}/edit"
  def new_link = "#{ENV.fetch('ROOT_URL')}/pages/new?page[slug]=#{@slug}"
end
