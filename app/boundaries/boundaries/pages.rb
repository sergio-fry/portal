# frozen_string_literal: true

require 'platform85/repo/dynamic_collection'
require 'platform85/repo/changes_repository'

module Boundaries
  class Pages
    include Dependencies[db: 'db.pages', ipfs: 'ipfs.ipfs']
    include Enumerable

    def initialize(db:, ipfs:)
      super
      @changes = Platform85::Repo::ChangesRepository.new(attrs: [:slug])
    end

    def find_aggregate(slug)
      record = db.find_by_slug slug

      found = Page.new(
        id: record.id,
        slug:,
        updated_at: record.updated_at,
        source_content: record.content
      )

      changes_for(found).commit

      found
    end

    def home = find_aggregate(ENV.fetch('HOME_TITLE', 'home'))

    def changes_for(page) = @changes.for(page)

    def page_cid(page)
      db.find_by_slug(page.slug).ipfs_cid
    end

    def save_aggregate(page)
      db.transaction do
        record = page.exists? ? db.find(page.id) : db.find_or_initialize_by_slug(page.slug)

        record.slug = page.slug if changes_for(page).changed?(:slug)

        if changes_for(page).changed?(:source_content)
          record.versions.build(ipfs_cid: record.ipfs_cid, created_at: record.updated_at) if record.persisted?
          record.ipfs_cid = ipfs.new_content(page.processed_content_with_layout).cid
          record.content = page.source_content
        end

        update_links_new(page, record)

        # TODO: protect from cyclic dependencies
        page.linked_pages.each { |linked_page| save_aggregate(linked_page) }

        record.save!
        page.instance_variable_set('@id', record.id)
      end
    end

    def linked_pages(page)
      Platform85::Repo::DynamicCollection.new do
        if page.exists?
          db.linked_pages(page.id).map { |rec| find_aggregate(rec.slug) }
        else
          []
        end
      end
    end

    def referenced_pages(page)
      Platform85::Repo::DynamicCollection.new do
        if page.exists?
          db.referenced_pages(page.id).map { |rec| find_aggregate(rec.slug) }
        else
          []
        end
      end
    end

    def create(slug) = db.create(slug:)

    delegate :exists?, to: :db

    def each
      db.each do |record|
        yield Page.new(
          id: record.id,
          slug: record.slug,
          updated_at: record.updated_at,
          source_content: record.content
        )
      end
    end

    delegate :updated_at, to: :db

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
      Platform85::Repo::DynamicCollection.new do
        record = db.find_or_initialize_by_slug(page.slug)
        (record.versions || []).sort_by do |version|
          version.created_at || Time.zone.now
        end.each_with_index.map do |version, index|
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
