class PageLink
  attr_reader :markup

  def initialize(markup, page, pages: Pages.new, regexp: PageLinkRegexp.new)
    @page = page
    @markup = markup
    @pages = pages
    @regexp = regexp
  end

  def html
    "<a href='/pages/#{slug}'>#{name}</a>"
  end

  def slug
    matched_data[1].downcase.strip.gsub(/\s+/, "_")
  end

  def name
    matched_data[2] || matched_data[1]
  end

  def matched_data
    m = @regexp.match(@markup)

    raise "Wrong page link markup" if m.nil?

    m
  end
end
