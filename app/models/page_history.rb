# frozen_string_literal: true

class PageHistory
  include Hanami::Helpers

  def initialize(page)
    @page = page
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
      @page.versions.map(&:created_at).compact.max == @version
    end
  end
end
