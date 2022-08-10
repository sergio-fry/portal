class Pages
  def find_by_slug(slug)
    Page.find_by title: slug
  end
end
