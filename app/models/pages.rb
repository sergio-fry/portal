class Pages
  def find_by_slug(slug)
    Page.find_by slug: slug
  end

  def each
    Page.find_each { |page| yield page }
  end
end
