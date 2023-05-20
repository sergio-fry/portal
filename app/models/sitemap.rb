# frozen_string_literal: true

require_relative './ipfs/new_folder'

class Sitemap
  include Dependencies['pages', 'features']

  delegate :url, to: :ifps_folder

  def page_url(page)
    "#{url}/#{page.slug}.html"
  end

  def ifps_folder
    folder = Ipfs::NewFolder.new

    folder = folder.with_file('index.html', home.ipfs) if home.exists?

    @pages.each do |page|
      folder = folder.with_file("#{page.slug}.html", page.ipfs)

      if features.enabled?(:history)
        history = Ipfs::NewFolder.new.with_file('history.html', page.history_ipfs_content)
        folder = folder.with_file(page.slug, history)
      end
    end

    folder
  end

  def home
    pages.find_by_slug ENV.fetch('HOME_TITLE', 'home')
  end
end
