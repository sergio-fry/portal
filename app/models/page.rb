class Page
  def initialize(slug)
    @slug = slug
  end

  # def move(new_slug)

  def content=(new_content)
    Boundaries::Database::Page.find_or_initialize_by(slug: @slug).tap do |page|
      page.content = new_content
      page.save!
    end
  end

  def content
    Boundaries::Database::Page.find_or_initialize_by(slug: @slug).content
  end

  def exists?
    content != ""
  end


  # def ipfs
  # def history
  # def incoming_links
  # def outgoing_links

  private

  def storage

  end
end
