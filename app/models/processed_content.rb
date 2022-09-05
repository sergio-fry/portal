# frozen_string_literal: true

require 'kramdown'

class ProcessedContent
  def initialize(page, ipfs: false)
    @ipfs = ipfs
    @page = page
  end

  def to_s
    converted_to_html(
      with_page_links(
        page_content
      )
    )
  end

  def page_content
    @page.content.to_s
  end

  def page_links
    PageLinkRegexp.new.scan(page_content).flatten.uniq.map do |markup|
      HtmlLink.new(PageLinkFromMarkup.new(markup), prefetch: true)
    end
  end

  private

  attr_reader :page

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
