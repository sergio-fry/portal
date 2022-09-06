# frozen_string_literal: true

require "rails_helper"
require "pundit/rspec"

RSpec.describe PagePolicy, type: :policy do
  subject { described_class }
  let(:user) { User.new }
  let(:guest) { nil }
  let(:page) { FactoryBot.build :page }

  permissions :show? do
    it { expect(subject).to permit(user, page) }
    it { expect(subject).to permit(guest, page) }
  end
  permissions :edit? do
    it { expect(subject).to permit(user, page) }
    it { expect(subject).not_to permit(guest, page) }
  end
  permissions :destroy? do
    it { expect(subject).to permit(user, page) }
    it { expect(subject).not_to permit(guest, page) }
  end
  permissions :update? do
    it { expect(subject).to permit(user, page) }
    it { expect(subject).not_to permit(guest, page) }
  end

  permissions ".scope" do
  end
end
