class PageHistory
  def initialize(page)
    @page = page
  end

  def to_s
    page = @page
    Layout.new(title: "History").wrap do |html|
      html.h1 do
        "History of #{page.title}"
      end

      html.ol reversed: :reversed do
        versions.each do |version|
          li do
            if version.has_link?
              a version.title, href: version.url, title: version.meta_title
            else
              span version.title
            end
          end
        end
      end
    end
  end

  def versions
    [CurrentVersion.new(@page, number: 0)] +
      @page.versions.order("created_at").each_with_index.map do |version, index|
        Version.new(version, number: index + 1)
      end.reverse
  end

  class Version
    def initialize(version, number:)
      @version = version
      @number = number
    end

    # FIXME: Folder URL.
    # NOTE: Is it possible?
    def url = Ipfs::Content.new(@version.ipfs_cid).url

    def title = @version.created_at

    def meta_title = "Version #{@number}"

    def has_link?
      true
    end
  end

  class CurrentVersion
    def initialize(page, number:)
      @page = page
      @number = number
    end

    def title
      "#{Time.now.utc} - Current"
    end

    # TODO: link to current version could be generated via folder URL
    def has_link?
      true
    end

    def url
      "../#{@page.slug}.html"
    end

    def meta_title = "Version #{@number}"
  end
end
