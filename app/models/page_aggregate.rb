# frozen_string_literal: true

class PageAggregate
  attr_reader :id, :slug, :updated_at, :history
  attr_accessor :source_content

  def initialize(
    id:,
    slug:,
    updated_at:,
    history: PageHistory.new(self),
    source_content: ''
  )
    @id = id
    @slug = slug
    @updated_at = updated_at
    @source_content = source_content
    @history = history
  end

  def exists? = @id.present?
  alias title slug

  def processed_content = ProcessedContent.new(@source_content)

  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  def content = processed_content.to_s

  def slug=(new_slug)
    return if @slug == new_slug

    @slug_before_moving = @slug
    @slug = new_slug
    update_backlinks
  end

  def update_backlinks

  end
end
