require_relative "./ipfs/new_folder"

class Sitemap
  def initialize(pages: Pages.new)
    @pages = pages
  end

  def ifps_folder
    folder = Ipfs::NewFolder.new

    home = @pages.find_by_slug ENV.fetch("HOME_TITLE", "home")
    folder = folder.with_file("index.html", home.ipfs_content)

    @pages.each do |page|
      folder = folder.with_file("#{page.slug}.html", page.ipfs_content)
      history = Ipfs::NewFolder.new.with_file("history.html", Ipfs::NewContent.new(page.history.to_s))

      folder = folder.with_file(page.slug, history)
    end

    folder
  end
end
