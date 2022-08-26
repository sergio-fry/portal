require "app/models/sitemap"
require "app/models/ipfs/new_content"

module SitemapTest
  class FakePages
    def initialize
      @pages = []
    end

    def <<(page)
      @pages << page
    end

    def each
      @pages.each { |page| yield page }
    end

    def find_by_slug(slug)
      @pages.find { |page| page.slug.to_s == slug.to_s }
    end
  end

  RSpec.describe Sitemap do
    subject(:sitemap) { described_class.new pages: pages }
    let(:pages) { FakePages.new }

    let(:home) { double(:home, slug: "home", ipfs_content: Ipfs::NewContent.new("Hello"), history: "Some hist") }
    before { pages << home }

    it { expect(sitemap.ifps_folder.file("index.html").data).to include "Hello" }
  end
end
