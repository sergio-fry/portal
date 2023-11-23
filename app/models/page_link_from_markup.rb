# frozen_string_literal: true

class PageLinkFromMarkup
  attr_reader :markup
  include Dependencies[:pages]

  def initialize(markup, regexp: PageLinkRegexp.new, pages:)
    @markup = markup
    @regexp = regexp
    @pages = pages
  end

  def css_classes
    if target_exists?
      'link'
    else
      'link link_missing'
    end
  end

  def link
    if target_exists?
      "#{canonical.link}.html"
    else
      canonical.new_link
    end
  end

  def canonical = CanonicalLink.new(slug)

  def target_exists?
    !page.nil?
  end

  def slug
    matched_data[1].downcase.strip.gsub(/\s+/, '_')
  end

  def name
    matched_data[2] || matched_data[1]
  end

  def page
    return unless pages.exists?(slug)

    pages.find_aggregate slug
  end

  alias target_page page

  def matched_data
    m = @regexp.match(@markup)

    raise 'Wrong page link markup' if m.nil?

    m
  end

  def moved_to(slug)
    self.class.new(
      "[[#{slug}|#{name}]]",
      regexp: @regexp,
      pages: pages
    )
  end
end
