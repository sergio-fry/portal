module Boundaries
  class Pages
    include Dependencies[db: 'db.pages']

    def find_by_slug(slug)
      ::Page.new slug
    end

    delegate :exists?, to: :db

    def each(&)
      db.each(&)
    end

    delegate :updated_at, to: :db

    def update_links(page)
      active_links = page.links.find_all(&:target_exists?)

      record = db.find_or_initialize_by_slug(page.slug)

      same_links = record.links.find_all { |rec| active_links.map(&:slug).include? rec.slug }
      new_links = active_links.reject { |link| same_links.map(&:slug).include? link.slug }.map do |link|
        record.links.build(slug: link.slug, target_page: link.page.record)
      end

      record.links = same_links + new_links
      record.save!
    end
  end
end
