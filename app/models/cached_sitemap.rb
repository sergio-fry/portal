# frozen_string_literal: true

class CachedSitemap
  def initialize(sitemap)
    @sitemap = sitemap
  end

  def url
    Rails.cache.fetch "CachedSitemap.url:#{pages.updated_at.to_i}" do
      @sitemap.url
    end
  end

  def page_url(page)
    "#{url}/#{page.slug}.html"
  end

  def pages
    @sitemap.pages
  end
end
