# frozen_string_literal: true

require 'app/boundaries/boundaries/ipfs/new_content'
require 'app/boundaries/boundaries/ipfs/new_folder'

module Boundaries
  module Ipfs
    RSpec.describe Folder do
      let(:cid) { NewFolder.new.with_file('/foo', NewContent.new('content')).cid }
      let(:folder) { described_class.new(cid) }

      it { expect(folder.file('/foo').data).to eq 'content' }
    end
  end
end
