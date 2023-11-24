module TagProcessors
  class Sitemap
    include Dependencies[:pages]

    def call(content)
      content = content.dup

      content.scan('<sitemap />').each do |tag|
        content.gsub!(tag, processed(tag))
      end

      content
    end

    def processed(_tag)
      links = []

      pages.entries.sort_by(&:updated_at).reverse.each do |page|
        links << "[[#{page.slug}]]"
      end

      links.join(' ')
    end
  end
end
