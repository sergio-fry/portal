# frozen_string_literal: true

class Sitemap
  include Dependencies['pages', 'features', ipfs: 'ipfs.ipfs']

  delegate :url, to: :ifps_folder

  def page_url(page)
    "#{url}/#{page.slug}.html"
  end

  def ifps_folder
    folder = ipfs.new_folder

    folder = folder.with_file('index.html', home.ipfs_content) if home.exists?

    @pages.each do |page|
      folder = folder.with_file("#{page.slug}.html", page.ipfs_content)
    end

    folder
  end

  def home
    pages.find_by_slug ENV.fetch('HOME_TITLE', 'home')
  end
end
