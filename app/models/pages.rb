class Pages
  def find_by_slug(slug)
    Page.find_by slug: slug
  end
end
