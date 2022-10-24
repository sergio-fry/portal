# frozen_string_literal: true

class PageLinkFromMarkup
  attr_reader :markup

  def initialize(markup, regexp: PageLinkRegexp.new, pages: Boundaries::Database::Pages.new)
    @markup = markup
    @regexp = regexp
    @pages = pages
  end

  def css_classes
    if target_exists?
      "link"
    else
      "link link_missing"
    end
  end

  def link
    "#{slug}.html"
  end

  def canonical
    CanonicalLink.new(link).link
  end

  def target_exists?
    !page.nil?
  end

  def slug
    matched_data[1].downcase.strip.gsub(/\s+/, "_")
  end

  def name
    matched_data[2] || matched_data[1]
  end

  def page
    return unless @pages.exists?(slug)

    @pages.find_by_slug slug
  end

  def matched_data
    m = @regexp.match(@markup)

    raise "Wrong page link markup" if m.nil?

    m
  end

  def moved_to(slug)
    self.class.new(
      "[[#{slug}|#{name}]]",
      regexp: @regexp,
      pages: @pages
    )
  end
end
