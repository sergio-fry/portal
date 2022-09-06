# frozen_string_literal: true

class HtmlLink
  def initialize(link)
    @link = link
  end

  def html
    result = ""

    result += "<a href='#{@link.link}' class='#{@link.css_classes}' data-link='#{@link.link}' data-canonical-link='#{@link.canonical}'>#{@link.name}</a>"

    result
  end

  delegate :markup, :page, :target_exists?, :slug, :moved_to, to: :@link
end
