class Page < ApplicationRecord
  def to_param
    title
  end

  def processed_content
    ProcessedContent.new(self)
  end

  def cid
    ipfs = IPFS::Connection.new
    folder = IPFS::Upload.folder("wrapper") do |wrapper|
      wrapper.add_file("index.html") do |fd|
        fd.write processed_content.to_s
      end
    end

    result = nil

    ipfs.add folder do |node|
      # display each uploaded node:
      print "#{node.name}: #{node.hash}\n" if node.finished?
      result = node.hash if node.folder?
    end

    result
  end
end
