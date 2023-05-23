# frozen_string_literal: true

require 'rails_helper'

require 'spec/fake/ipfs/gateway'

module SitemapTest
  class FakePages
    def initialize
      @pages = []
    end

    def <<(page)
      @pages << page
    end

    def each(&)
      @pages.each(&)
    end

    def find_by_slug(slug)
      @pages.find { |page| page.slug.to_s == slug.to_s }
    end
  end

  RSpec.describe Sitemap do
    before do
      Dependencies.container.stub('ipfs.gateway', Fake::Ipfs::Gateway.new)
      pages << home
    end
    let(:ipfs) { DependenciesContainer.resolve('ipfs.ipfs') }

    after { Dependencies.container.unstub 'ipfs.gateway' }

    subject(:sitemap) { described_class.new pages: }
    let(:pages) { FakePages.new }

    let(:home) do
      double(:home, slug: 'home', ipfs_content: ipfs.new_content('Hello'),
                    exists?: true)
    end

    it { expect(sitemap.ifps_folder.file('index.html').data).to include 'Hello' }
  end
end
