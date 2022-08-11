class PageLink
  attr_reader :markup

  def initialize(markup, regexp: PageLinkRegexp.new, pages: Pages.new)
    @markup = markup
    @regexp = regexp
    @pages = pages
  end

  def html
    if !page.nil?
      "<a href='#{page.ipfs.url(only_path: true)}' class='link'>#{name}</a>"
    else
      "<a href='#' class='link link_missing'>#{name}</a>"
    end
  end

  def slug
    matched_data[1].downcase.strip.gsub(/\s+/, "_")
  end

  def name
    matched_data[2] || matched_data[1]
  end

  def page
    @pages.find_by_slug slug
  end

  def matched_data
    m = @regexp.match(@markup)

    raise "Wrong page link markup" if m.nil?

    m
  end
end
