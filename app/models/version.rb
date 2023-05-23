# frozen_string_literal: true

class Version
  attr_reader :number

  def initialize(page, version, number:)
    @page = page
    @version = version
    @number = number
  end

  def url
    if current?
      "../#{@page.slug}.html"
    else
      Ipfs::Content.new(@version.ipfs_cid).url
    end
  end

  def title = time

  def time = @version.created_at || Time.now.utc

  def meta_title = "Version #{@number}"

  def current?
    @page.history.current_version == self
  end

  def created_at = @version.created_at
end
