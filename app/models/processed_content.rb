# frozen_string_literal: true

require 'kramdown'

class ProcessedContent
  def initialize(content)
    @content = content
  end

  def to_s
    converted_to_html(
      with_page_links(
        @content
      )
    )
  end

  def page_links
    PageLinkRegexp.new.scan(@content).flatten.uniq.map do |markup|
      HtmlLink.new(PageLinkFromMarkup.new(markup))
    end
  end

  private

  def converted_to_html(content)
    Kramdown::Document.new(content).to_html
  end

  def with_page_links(content)
    content = content.dup

    page_links.each do |link|
      content.gsub!(link.markup, link.html)
    end

    content
  end
end
