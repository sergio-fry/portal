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
    let!(:page) { Page.new :politics }
    let!(:linked_page) { Page.new :main }
    before { linked_page.source_content = "Here is some [[politics]]" }

    it { expect(page.linked_pages).to include linked_page }

    context "when link removed" do
      before { linked_page.source_content = "Here was some politics" }
      it { expect(page.linked_pages).not_to include linked_page }
    end
  end
end
