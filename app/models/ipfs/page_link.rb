module Ipfs
  class PageLink
    def initialize(page_link)
      @page_link = page_link
    end

    def markup = @page_link.markup

    def html
      "<a href='#{link}' class='#{css_classes}'>#{name}</a>"
    end

    def link
      if @page_link.target_exists?
        @page_link.page.ipfs.url(only_path: true)
      else
        "#"
      end
    end
  end
end
