class ProcessedContent
  def initialize(page)
    @page = page
  end

  def to_s
    content = @page.content.to_s
    content = insert_page_links content
    content
  end

  def insert_page_links(content)
    content = content.dup

    page_link_tags(content).each do |link|
      content.gsub!(link.markup, link.html)
    end

    content
  end

  def page_link_tags(content)
    PageLinkRegexp.new.scan(content).flatten.uniq.map do |markup|
      PageLink.new(markup, @page)
    end
  end
end
