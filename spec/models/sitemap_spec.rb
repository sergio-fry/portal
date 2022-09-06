# frozen_string_literal: true

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

    def each(&block)
      @pages.each(&block)
    end

    def find_by_slug(slug)
      @pages.find { |page| page.slug.to_s == slug.to_s }
    end
  end

  RSpec.describe Sitemap do
    subject(:sitemap) { described_class.new pages: }
    let(:pages) { FakePages.new }

    let(:home) do
      double(:home, slug: "home", ipfs_content: Ipfs::NewContent.new("Hello"),
        history_ipfs_content: Ipfs::NewContent.new("Some hist"))
    end
    before { pages << home }

    it { expect(sitemap.ifps_folder.file("index.html").data).to include "Hello" }
  end
end
