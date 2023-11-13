# frozen_string_literal: true

class Sitemap
  include Dependencies['pages', 'features', ipfs: 'ipfs.ipfs']

  delegate :url, to: :ifps_folder

  def page_url(page)
    "#{url}/#{page.slug}.html"
  end

  # FIXME: typo ipfs
  def ifps_folder
    folder = ipfs.new_folder

    if home.exists?
      folder = folder.with_file('index.html', page_ipfs_content(home))
      folder = folder.with_file("#{home.slug}.html", page_ipfs_content(home))
    end

    @pages.each do |page|
      folder = folder.with_file("#{page.slug}.html", page_ipfs_content(page))
    end

    folder
  end

  def home
    pages.find_aggregate ENV.fetch('HOME_TITLE', 'home')
  end

  def page_ipfs_content(page) = ipfs.new_content(page.processed_content_with_layout)
end
