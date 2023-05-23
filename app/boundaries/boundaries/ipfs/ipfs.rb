module Boundaries
  module Ipfs
    class Ipfs
      def content(cid) = Content.new(cid)
      def new_content(data) = NewContent.new(data)
      def new_folder = NewFolder.new
    end
  end
end
