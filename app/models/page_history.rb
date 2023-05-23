# frozen_string_literal: true

class PageHistory
  include Hanami::Helpers

  include Dependencies[pages: 'pages']

  def initialize(page, pages:, versions: pages.versions(page))
    @page = page
    @pages = pages
    @versions = versions
  end

  def to_s
    page = @page
    html do
      html.div do
        div.h1 do
          "History of #{page.title}"
        end

        div.ol reversed: :reversed do
          versions.each do |version|
            li do
              a version.title, href: version.url, title: version.meta_title

              a 'Current', href: version.url if version.current?
            end
          end
        end
      end
    end.to_s
  end

  def versions
    @versions.sort_by(&:created_at).reverse
  end

  def current_version
    versions.max_by(&:created_at)
  end
end
