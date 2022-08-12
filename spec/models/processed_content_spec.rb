require "rails_helper"

RSpec.describe ProcessedContent do
  subject { described_class.new page, ipfs: ipfs }
  let(:ipfs) { false }
  let(:page) { Page.new content: content }

  context do
    let(:content) { "Text with link to [[page1]]" }

    it { expect(subject.to_s).to match(/Text with link to <a.*>page1<\/a>/) }
  end

  context "with ipfs" do
    before { FactoryBot.create :page, title: "page1" }
    let(:ipfs) { true }
    let(:content) { "Text with link to [[page1]]" }

    it { expect(subject.to_s).to match(/Text with link to <a.*>page1<\/a>/) }
  end
end
