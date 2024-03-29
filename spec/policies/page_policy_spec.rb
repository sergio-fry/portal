# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'
require 'spec/fake/ipfs/gateway'

RSpec.describe PagePolicy, type: :policy do
  subject(:policy) { described_class }

  before { Dependencies.container.stub('ipfs.gateway', Fake::Ipfs::Gateway.new) }
  after { Dependencies.container.unstub 'ipfs.gateway' }

  let(:user) { build(:user) }
  let(:guest) { nil }
  let(:page) { build :page, slug: :main }

  permissions :show? do
    it { is_expected.to permit(user, page) }
    it { is_expected.to permit(guest, page) }
  end
  permissions :edit? do
    it { is_expected.to permit(user, page) }
    it { is_expected.not_to permit(guest, page) }
  end
  permissions :update? do
    it { is_expected.to permit(user, page) }
    it { is_expected.not_to permit(guest, page) }
  end

  # permissions '.scope' do
  # end
end
