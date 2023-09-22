require 'app/models/page_aggregate'
require 'app/models/processed_content'
require 'app/models/page_link_regexp'
require 'app/models/html_link'
require 'app/models/page_link_from_markup'

module PageAggregateTesting
  class FakePages
    def initialize
      @linked_pages = Hash.new([])
    end

    def link_pages(page, linked_pages)
      @linked_pages[page] = linked_pages
    end

    def linked_pages(page)
      @linked_pages[page]
    end

    def referenced_pages(page)
      []
    end

  end
end

RSpec.describe PageAggregate, 'links', :focus do
  def next_id
    @next_id ||= 0
    @next_id += 1
  end

  let(:fake_pages) { PageAggregateTesting::FakePages.new }

  def page(slug, source_content, linked_pages)
    new_page = PageAggregate.new(
      id: next_id,
      slug: 'page',
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
    linked = page('page1', '[[root]]', [])
    root = page('root', '', [linked])

    root.slug = 'home'


    expect(linked.processed_content.page_links[0].slug).to eq 'home'
  end
end
