# frozen_string_literal: true

class Version
  include Dependencies['ipfs.ipfs']
  attr_reader :number

  # TODO: avoid pass version record
  def initialize(page, version, number:, ipfs:)
    @page = page
    @version = version
    @number = number
    @ipfs = ipfs
  end

  def url
    if current?
      "../#{@page.slug}.html"
    else
      ipfs.content(@version.ipfs_cid).url
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
