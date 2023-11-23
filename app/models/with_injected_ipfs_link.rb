# frozen_string_literal: true

class WithInjectedIpfsLink
  def initialize(html, page)
    @html = html
    @page = page
  end

  def to_s
    doc = Nokogiri::HTML(@html)
    article = doc.css('article')
    article.attr('data-ipfs-url', @page.url)
    article.attr('class', 'ipfs-page')

    doc.to_s
  end
end
