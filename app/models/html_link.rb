class HtmlLink
  def initialize(link)
    @link = link
  end

  def html
    "<a href='#{@link.link}' class='#{@link.css_classes}'>#{@link.name}</a>"
  end

  def markup = @link.markup
end
