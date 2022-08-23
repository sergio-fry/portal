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
        page.versions.order("created_at").each_with_index.map do |version, index|
          [version, index + 1]
        end.reverse_each do |version, number|
          li do
            a version.created_at, href: Ipfs::Content.new(version.ipfs_cid).url, title: "Version #{number}"
          end
        end
      end
    end
  end
end
