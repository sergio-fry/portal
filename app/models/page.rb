class Page < ApplicationRecord
  has_rich_text :content

  def to_param
    title
  end

  def processed_content
    ProcessedContent.new(self)
  end
end
