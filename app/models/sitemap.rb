require_relative "./ipfs/new_folder"

class Sitemap
  def initialize(pages: Pages.new)
    @pages = pages
  end

  def ifps_folder
    folder = Ipfs::NewFolder.new

    folder = folder.with_file("index.html", home.ipfs_content) if home_exists?

    @pages.each do |page|
      folder = folder.with_file("#{page.slug}.html", page.ipfs_content)
      history = Ipfs::NewFolder.new.with_file("history.html", page.history_ipfs_content)

      folder = folder.with_file(page.slug, history)
    end

    folder
  end

  def home
    @pages.find_by_slug ENV.fetch("HOME_TITLE", "home")
  end

  def home_exists?
    !home.nil?
  end
end
