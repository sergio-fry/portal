class Page < ApplicationRecord
  has_rich_text :content

  def to_param
    title
  end
end
