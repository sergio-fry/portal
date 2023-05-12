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

  describe '#linked_pages' do
    let!(:politics) { described_class.new :politics }
    let!(:main) { described_class.new :main }

    before do
      politics.source_content = 'politics here'
      main.source_content = 'Find politics here: [[politics]]'
    end

    it { expect(politics.linked_pages).to include main }

    context 'when link removed' do
      before { main.source_content = 'Find politics by yourself!' }

      it { expect(politics.linked_pages).not_to include main }
    end

    context 'when target page moved' do
      before { politics.move :news }

      it { expect(politics.linked_pages).to include main }
    end
  end
end
