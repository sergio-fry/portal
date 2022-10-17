require "rails_helper"
require "spec/fake/ipfs/gateway"

RSpec.describe Page do
  before { Dependencies.container.stub(:ipfs, Fake::Ipfs::Gateway.new) }
  after { Dependencies.container.unstub :ipfs }

  describe "#ipfs" do
    let(:page) { Page.new :main }
    before { page.source_content = "Text [[page]] " }

    subject { page.ipfs.cid }
    it { is_expected.to be_present }
  end

  describe "#linked_pages" do
    let!(:page) { FactoryBot.create :page, slug: "politics" }
    let!(:linked_page) { FactoryBot.create :page, content: "Here is some [[politics]]" }

    it { expect(page.linked_pages.reload).to include linked_page }

    context "when link removed" do
      before { linked_page.update_attribute :content, "Here was some politics" }
      it { expect(page.linked_pages.reload).not_to include linked_page }
    end
  end
end
