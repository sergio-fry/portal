# frozen_string_literal: true

require 'app/boundaries/boundaries/ipfs/new_content'
require 'app/boundaries/boundaries/ipfs/new_folder'

module Boundaries
  module Ipfs
    RSpec.describe NewFolder do
      let(:hello) { NewContent.new('hello') }

      it do
        folder = described_class.new

        expect(
          folder.with_file('/hello.txt', NewContent.new('hello'))
            .file('/hello.txt').data
        ).to eq 'hello'
      end
    end
  end
end
