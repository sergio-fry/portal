module Boundaries
  class Pages
    include Dependencies[db: 'db.pages']

    def find_by_slug(slug)
      ::Page.new slug
    end

    def exists?(slug) = db.exists?(slug)

    def each
      db.each do |page|
        yield page
      end
    end

    def updated_at = db.updated_at
  end
end
