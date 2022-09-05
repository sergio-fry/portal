# frozen_string_literal: true

class Page < ApplicationRecord
  before_save :update_backlinks

  has_many :back_links, foreign_key: :target_page_id, class_name: 'Link', autosave: true
  has_many :linked_pages, through: :back_links, source: :page, class_name: 'Page'
  has_many :linking_to_pages, through: :links, source: :target_page, class_name: 'Page'
  has_many :links
  has_many :versions, class_name: 'PageVersion', autosave: true

  validates :slug, format: { with: /\A[a-zа-я0-9\-_]+\z/ }, uniqueness: true, presence: true
  validates :content, presence: true

  def to_param
    slug
  end

  def title
    slug
  end

  def processed_content
    ProcessedContent.new(self)
  end

  def processed_content_with_layout
    PageLayout.new(
      processed_content.to_s,
      self
    ).to_s
  end

  def ipfs_content
    ipfs_cid.present? ? Ipfs::Content.new(ipfs_cid) : ipfs_new_content
  end

  def ipfs_new_content
    Ipfs::NewContent.new(
      processed_content_with_layout
    )
  end

  def sync_to_ipfs
    self.ipfs_cid = ipfs_new_content.cid
  end

  def content=(value)
    super

    return unless content_changed?

    add_new_links
    links.destroy removed_links
    sync_to_ipfs
    track_history
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

  private

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

  def update_backlinks
    return unless slug_changed?

    back_links.each do |link|
      link.slug = slug
    end
  end
end
