module Ipfs
  class PageLink
    def initialize(page_link)
      @page_link = page_link
    end

    def markup = @page_link.markup

    def css_classes = @page_link.css_classes

    def name = @page_link.name

    def link
      if @page_link.target_exists?
        @page_link.page.ipfs_content.url
      else
        "#"
      end
    end
  end
end
