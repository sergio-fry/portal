# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'
require 'spec/fake/ipfs/gateway'

RSpec.describe PagePolicy, type: :policy do
  subject { described_class }

  before { Dependencies.container.stub(:ipfs, Fake::Ipfs::Gateway.new) }
  after { Dependencies.container.unstub :ipfs }

  let(:user) { build(:user) }
  let(:guest) { nil }
  let(:page) { Page.new :main }

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

  permissions '.scope' do
  end
end
