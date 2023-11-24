# frozen_string_literal: true

require 'kramdown'

class ProcessedContent
  include Dependencies[:pages]

  def initialize(content, pages:)
    @content = content
    @pages = pages
  end

  def to_s
    converted_to_html(
      with_page_links(
        with_tags_processed(
          @content
        )
      )
    )
  end

  def page_links(content=@content)
    PageLinkRegexp.new.scan(content).flatten.uniq.map do |markup|
      HtmlLink.new(PageLinkFromMarkup.new(markup))
    end
  end

  private

  def tag_processors
    [
      TagProcessors::Sitemap.new(pages:)
    ]
  end

  def with_tags_processed(content)
    content = content.dup

    tag_processors.each do |processor|
      content = processor.call(content)
    end

    content
  end

  def converted_to_html(content)
    Kramdown::Document.new(content).to_html
  end

  def with_page_links(content)
    content = content.dup

    page_links(content).each do |link|
      content.gsub!(link.markup, link.html)
    end

    content
  end
end
