class Page < ApplicationRecord
  def to_param
    title
  end

  def processed_content
    ProcessedContent.new(self)
  end

  def ipfs
    IpfsFile.new(processed_content)
  end
end
