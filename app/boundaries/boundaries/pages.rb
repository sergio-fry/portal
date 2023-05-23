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
  end
end
