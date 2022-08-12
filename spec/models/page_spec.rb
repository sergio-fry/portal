require "rails_helper"

RSpec.describe Page, type: :model do
  describe "#ipfs" do
    let(:page) { FactoryBot.build :page, content: content }
    let(:content) { "Text [[page]] " }

    subject { page.ipfs.cid }
    it { is_expected.to be_present }
  end
end
