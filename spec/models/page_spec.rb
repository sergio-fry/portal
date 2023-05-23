# frozen_string_literal: true

require 'rails_helper'
require 'spec/fake/ipfs/gateway'

RSpec.describe Page do
  before { Dependencies.container.stub(:ipfs, Fake::Ipfs::Gateway.new) }
  after { Dependencies.container.unstub :ipfs }

  describe '#ipfs' do
    subject { page.ipfs.cid }

    let(:page) { described_class.new :main }

    before { page.source_content = 'Text [[page]] ' }

    it { is_expected.to be_present }
  end
end
