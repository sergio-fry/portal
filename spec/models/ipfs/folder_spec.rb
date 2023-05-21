# frozen_string_literal: true

require 'app/models/ipfs/new_content'
require 'app/models/ipfs/new_folder'

module Ipfs
  RSpec.describe Folder do
    let(:cid) { NewFolder.new.with_file('/foo', NewContent.new('content')).cid }
    let(:folder) { described_class.new(cid) }

    it { expect(folder.file('/foo').data).to eq 'content' }

    context 'when cid is set' do
      let(:cid) { 'QmRc2HE8j3nab7W8ELUtJs48pjbwHrrTeSzJEKtH8WUb1G' }

      it { expect(folder.file('faq.html').data).to eq 'content' }
    end
  end
end
