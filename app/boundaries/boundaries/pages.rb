# frozen_string_literal: true

module Boundaries
  class Pages
    include Dependencies[db: 'db.pages']

    def find_aggregate(slug)
      record = db.find_by_slug slug

      PageAggregate.new(
        id: record.id,
        slug: slug,
        updated_at: record.updated_at,
        source_content: record.content,
      )
    end

    def find_by_slug(slug)
      ::Page.new slug
    end

    delegate :exists?, to: :db

    def each(&) = db.each(&)

    delegate :updated_at, to: :db

    def update_links(page)
      with_record(page) do |record|
        active_links = page.links.find_all(&:target_exists?)

        same_links = record.links.find_all { |rec| active_links.map(&:slug).include? rec.slug }
        new_links = active_links.reject { |link| same_links.map(&:slug).include? link.slug }.map do |link|
          record.links.build(slug: link.slug, target_page: link.page)
        end

        record.links = same_links + new_links
        record.save!
      end
    end

    def versions(page)
      DynamicCollection.new do
        record = db.find_or_initialize_by_slug(page.slug)
        (record.versions || []).sort_by { |version| version.created_at || Time.zone.now }.each_with_index.map do |version, index|
          Version.new(page, cid: version.ipfs_cid, created_at: version.created_at, number: index + 1)
        end.reverse
      end
    end

    private

    def with_record(page)
      yield db.find_or_initialize_by_slug(page.slug)
    end
  end
end
