require "rails_helper"

RSpec.describe Page, type: :model do
  describe "#ipfs" do
    let(:page) { FactoryBot.build :page, content: content }
    let(:content) { "Text [[page]] " }

    subject { page.ipfs_content.cid }
    it { is_expected.to be_present }
  end

  describe "#linked_pages" do
    let!(:page) { FactoryBot.build :page }
    let!(:linked_page) { FactoryBot.build :page }

    before { BackLink.create page: page, source_page: linked_page }

    it { expect(page.linked_pages.reload).to include linked_page }
  end
end
