require "app/models/page_link_regexp"
require "app/models/page_link"

RSpec.describe PageLink do
  subject(:page_link) { described_class.new(markup, page) }
  let(:page) { double(:page) }

  context do
    let(:markup) { "[[main]]" }
    it { expect(page_link.html).to include "main" }
    it { expect(page_link.slug).to eq "main" }
    it { expect(page_link.name).to eq "main" }
  end

  context do
    let(:markup) { "[[main|Main]]" }
    it { expect(page_link.slug).to eq "main" }
    it { expect(page_link.name).to eq "Main" }
  end

  context do
    let(:markup) { "[[multi_word|Multi Word]]" }
    it { expect(page_link.slug).to eq "multi_word" }
    it { expect(page_link.name).to eq "Multi Word" }
  end

  context do
    let(:markup) { "[[Multi Word]]" }
    it { expect(page_link.slug).to eq "multi_word" }
    it { expect(page_link.name).to eq "Multi Word" }
  end
end
