# frozen_string_literal: true

class Pages
  def find_by_slug(slug)
    Page.find_by slug:
  end

  def each(&block)
    Page.find_each(&block)
  end

  def updated_at
    Page.maximum(:updated_at)
  end
end
