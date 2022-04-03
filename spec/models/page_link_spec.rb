require 'app/models/page_link_regexp'
require 'app/models/page_link'

module Test
  class FakePages

  end
end
RSpec.describe PageLink do
  subject(:page_link) { described_class.new(markup, page, pages:) }
  let(:markup) { '[[foo]]' }
  let(:page) { double(:page) }
  let(:pages) { Test::FakePages.new }

  describe '#html' do
    subject(:html) { page_link.html }

    context do
      let(:markup) { '[[main]]' }
      it { is_expected.to include 'main' }
    end

    context do
      let(:markup) { '[[main|Main]]' }
      it { is_expected.to include 'Main' }
    end
  end
end
