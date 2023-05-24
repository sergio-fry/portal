# frozen_string_literal: true

class PageAggregate
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
  attr_reader :slug, :updated_at, :history, :source_content
  alias title slug

  def processed_content = ProcessedContent.new(@source_content)

  def processed_content_with_layout
    PageLayout.new(
      content,
      self
    ).to_s
  end

  def content = processed_content.to_s
end
