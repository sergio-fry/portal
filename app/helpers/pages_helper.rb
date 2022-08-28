module PagesHelper
  def ipfs_page_url(page)
    "#{Sitemap.new.ifps_folder.url}/#{page.slug}.html"
  end
end
