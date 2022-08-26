require "app/models/ipfs/new_content"
require "app/models/ipfs/new_folder"

module Ipfs
  RSpec.describe NewFolder do
    let(:hello) { NewContent.new("hello") }

    it do
      folder = described_class.new(
        "/hello.txt" => hello
      )

      expect(folder.content_at("/hello.txt").content).to eq "hello"
    end
  end
end
