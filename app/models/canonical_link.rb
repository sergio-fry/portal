# frozen_string_literal: true

class CanonicalLink
  def initialize(slug)
    @slug = slug
  end

  def link = "#{ENV.fetch('ROOT_URL')}/pages/#{@slug}"

  def edit_link = "#{link}/edit"
end
