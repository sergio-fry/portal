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

  REGEXP = /\[\[[[:alnum:]]+\]\]/

  def page_link_tags(content)
    content.scan(REGEXP).flatten.uniq.map do |markup|
      PageLink.new(markup, @page)
    end
  end
end
