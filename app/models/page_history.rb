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
              a version.title, href: version.url, title: version.meta_title, class: version_css_class(version)

              a 'Current', href: version.url, class: version_css_class(version) if version.current?
            end
          end
        end
      end
    end.to_s
  end

  class CurrentVersion
    include Dependencies['ipfs.ipfs']
    def initialize(page, ipfs:, number:)
      @page = page
      @number = number

      @ipfs = ipfs
    end
    
    def title = @page.updated_at
    def url = ""
    def meta_title = "Version #{@number}"
    def current? = true
  end

  def versions
    [current_version] + @versions.sort_by(&:created_at).reverse
  end

  def current_version
    CurrentVersion.new(@page, number: @versions.size + 1)
  end

  def version_css_class(version) = version.current? ? 'version--current' : ''
end
