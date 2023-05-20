# frozen_string_literal: true

class PageHistory
  def initialize(page)
    @page = page
  end

  def to_s
    page = @page
    Layout.new(title: 'History').wrap do |html|
      html.h1 do
        "History of #{page.title}"
      end

      html.ol reversed: :reversed do
        versions.each do |version|
          li do
            a version.title, href: version.url, title: version.meta_title

            if version.current?
              a 'Current', href: version.url
            end
          end
        end
      end
    end
  end

  def versions
    @page.versions.sort_by { |version| version.created_at || Time.zone.now }.each_with_index.map do |version, index|
      Version.new(@page, version, number: index + 1)
    end.reverse
  end

  class Version
    attr_reader :number

    def initialize(page, version, number:)
      @page = page
      @version = version
      @number = number
    end

    def url
      if current?
        "../#{@page.slug}.html"
      else
        Ipfs::Content.new(@version.ipfs_cid).url
      end
    end

    def title = time

    def time = @version.created_at || Time.now.utc

    def meta_title = "Version #{@number}"

    def current?
      @page.versions.max_by(&:created_at) == @version
    end
  end
end
