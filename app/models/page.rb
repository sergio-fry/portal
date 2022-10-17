class Page
  attr_reader :slug

  def initialize(slug)
    @slug = slug
  end

  def move(new_slug)
    # TODO
    update_backlinks new_slug
  end

  def source_content
    Boundaries::Database::Page.find_by(slug: @slug)&.content
  end

  def source_content=(new_content)
    Boundaries::Database::Page.find_or_initialize_by(slug: @slug).tap do |page|
      page.content = new_content
      page.save!
    end

    # TODO
    # add_new_links
    # links.destroy removed_links
    # sync_to_ipfs
    # track_history
  end

  def history
    PageHistory.new self
  end

  def history_ipfs_content
    history_ipfs_cid.present? ? Ipfs::Content.new(history_ipfs_cid) : Ipfs::NewContent.new(history.to_s)
  end

  def track_history
    versions.build ipfs_cid: ipfs_cid
    self.history_ipfs_cid = Ipfs::NewContent.new(history.to_s).cid
  end

  def removed_links
    links.reject { |link| active_links.map(&:page).include?(link.target_page) }
  end

  def new_links
    active_links.reject { |link| links.map(&:target_page).include? link.page }
  end

  def active_links
    processed_content.page_links.find_all(&:target_exists?)
  end

  def content
    processed_content.to_s
  end

  def processed_content
    ProcessedContent.new(source_content)
  end

  def exists?
    content != ""
  end


  # def ipfs
  # def history
  # def incoming_links
  # def outgoing_links


  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  def ipfs
    Ipfs::NewContent.new(
      processed_content_with_layout
    )
  end

  def sync_to_ipfs
    self.ipfs_cid = ipfs.cid
  end

  def add_new_links
    links.build(
      new_links.map do |link|
        {
          page: self,
          target_page: link.page,
          slug: link.page.slug
        }
      end
    )
  end

  def update_backlinks(new_slug)
    back_links.each do |link|
      link.slug = new_slug
    end
  end

  def updated_at
    Boundaries::Database::Page.find_by(slug: @slug)&.updated_at || Time.now
  end

  def versions
    Boundaries::Database::Page.find_by(slug: @slug)&.versions || []
  end
end
