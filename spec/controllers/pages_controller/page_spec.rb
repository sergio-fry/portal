require "rails_helper"

RSpec.describe PagesController::Page do
  subject { described_class.new page_object }
  let(:page_object) { FactoryBot.create :page }

  it { expect(subject.policy_class).to eq PagePolicy }
end

