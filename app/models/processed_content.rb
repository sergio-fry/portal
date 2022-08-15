require "kramdown"

class ProcessedContent
  def initialize(page, ipfs: false)
    @ipfs = ipfs
    @page = page
  end

  def to_s
    converted_to_html(
      with_page_links(
        @page.content.to_s
      )
    )
  end

  private

  attr_reader :page

  def converted_to_html(content)
    Kramdown::Document.new(content).to_html
  end

  def with_page_links(content)
    content = content.dup

    page_link_tags(content).each do |link|
      content.gsub!(link.markup, link.html)
    end

    content
  end

  def page_link_tags(content)
    PageLinkRegexp.new.scan(content).flatten.uniq.map do |markup|
      if @ipfs
        Ipfs::PageLink.new(
          PageLink.new(markup)
        )
      else
        PageLink.new(markup)
      end
    end
  end
end
