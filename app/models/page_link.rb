class PageLink
  attr_reader :markup

  def initialize(markup, page)
    @page = page
    @markup = markup
  end

  def html
    "<a href='/pages/#{slug}'>#{name}</a>"
  end

  def name
    @markup.match(/\[\[([[:alnum:]]+)\]\]/)[1]
  end

  def slug
    name
  end
end
