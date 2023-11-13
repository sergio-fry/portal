require 'app/models/page_aggregate'
require 'app/models/processed_content'
require 'app/models/page_link_regexp'
require 'app/models/html_link'
require 'app/models/page_link_from_markup'

module PageAggregateTesting
  class FakePages
    def initialize
      @linked_pages = Hash.new([])
      @pages = []
    end

    def <<(page)
      @pages << page
    end


    def exists?(slug)
      @pages.any? { |page| page.slug == slug }
    end

    def link_pages(page, linked_pages)
      @linked_pages[page.slug.to_s] = linked_pages
    end

    def linked_pages(page)
      Enumerator.new do |y|
        @linked_pages[page.slug.to_s].each do |page|
          y << page
        end
      end
    end

    def referenced_pages(_page)
      []
    end
  end
end

RSpec.describe PageAggregate, 'links' do
  def next_id
    @next_id ||= 0
    @next_id += 1
  end

  let(:fake_pages) { PageAggregateTesting::FakePages.new }

  def page(slug, source_content, linked_pages)
    new_page = PageAggregate.new(
      id: next_id,
      slug: slug,
      history: double,
      updated_at: Time.now,
      source_content:
    )

    fake_pages.link_pages new_page, linked_pages

    new_page
  end

  before { DependenciesContainer.stub(:pages, fake_pages) }
  after { DependenciesContainer.unstub(:pages) }

  it 'track links between pages' do
    linked = page('linked', '[[referenced]]', [])
    referenced = page('referenced', '', [linked])

    referenced.slug = 'new_slug'

    expect(linked.processed_content.page_links[0].slug).to eq 'new_slug'
  end
end
