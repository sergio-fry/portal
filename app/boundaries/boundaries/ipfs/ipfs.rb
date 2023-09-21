module Boundaries
  module Ipfs
    class Ipfs
      def content(cid) = Content.new(cid)
      def new_content(data) = NewContent.new(data)
      def new_folder = NewFolder.new
      def folder(cid) = Folder.new(cid)
    end
  end
end
