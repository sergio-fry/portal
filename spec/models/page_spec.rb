# frozen_string_literal: true

require "rails_helper"
require "spec/fake/ipfs/gateway"

RSpec.describe Page, type: :model, dependencies: true do
  before do
    Dependencies.container.stub(:ipfs, Fake::Ipfs::Gateway.new)
  end

  describe "slug validation" do
    it { expect(FactoryBot.build(:page, slug: "politics")).to be_valid }
    it { expect(FactoryBot.build(:page, slug: "Politics")).not_to be_valid }
    it { expect(FactoryBot.build(:page, slug: "история")).to be_valid }
  end

  describe "#ipfs" do
    let(:page) { FactoryBot.build :page, content: }
    let(:content) { "Text [[page]] " }

    subject { page.ipfs_content.cid }
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
