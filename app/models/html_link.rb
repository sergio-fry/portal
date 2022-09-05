# frozen_string_literal: true

class HtmlLink
  def initialize(link, prefetch:)
    @link = link
    @prefetch = prefetch
  end

  def html
    result = ''

    result << "<a href='#{@link.link}' class='#{@link.css_classes}'>#{@link.name}</a>"
    result << "<link rel='preload' href='#{@link.link}' as='fetch'>" if @prefetch

    result
  end

  delegate :markup, :page, :target_exists?, :slug, :moved_to, to: :@link
end
