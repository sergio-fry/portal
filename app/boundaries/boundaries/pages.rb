# frozen_string_literal: true

module Boundaries
  class Pages
    include Dependencies[db: 'db.pages', ipfs: 'ipfs.ipfs']

    def find_aggregate(slug)
      record = db.find_by_slug slug

      PageAggregate.new(
        id: record.id,
        slug:,
        updated_at: record.updated_at,
        source_content: record.content
      )
    end

    def save_aggregate(page)
      record = page.exists? ? db.find(page.id) : db.find_or_initialize_by_slug(page.slug)

      record.slug = page.slug
      record.content = page.source_content

      record.versions.build(ipfs_cid: record.ipfs_cid) if record.ipfs_cid.present?
      record.ipfs_cid = ipfs.new_content(page.processed_content_with_layout).cid

      update_links_new(page, record)

      # TODO: protect from cyclic dependencies
      page.linked_pages.each { |linked_page| save_aggregate(linked_page) }

      record.save!
    end

    def linked_pages(page)
      DynamicCollection.new do
        if page.exists?
          db.linked_pages(page.id).map { |rec| find_aggregate(rec.slug) }
        else
          []
        end
      end
    end

    def referenced_pages(page)
      DynamicCollection.new do
        if page.exists?
          db.referenced_pages(page.id).map { |rec| find_aggregate(rec.slug) }
        else
          []
        end
      end
    end

    def create(slug) = db.create(slug:)

    def find_by_slug(slug)
      ::Page.new slug
    end

    delegate :exists?, to: :db

    def each(&) = db.each(&)

    delegate :updated_at, to: :db

    # TODO: remove deprecated
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

    def update_links_new(page, record)
      record
        .links
        .filter { |link| page.linked_pages.map(&:id).exclude? link.target_page_id }
        .each(&:destroy)

      page
        .referenced_pages
        .filter { |linked_page| record.linking_to_page_ids.exclude? linked_page.id }
        .each do |linked_page|
          record.links.build(slug: linked_page.slug, page: record, target_page: db.find(linked_page.id))
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
