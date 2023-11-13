# frozen_string_literal: true

class Version
  include Dependencies['ipfs.ipfs']
  attr_reader :number, :created_at

  def initialize(page, cid:, created_at:, number:, ipfs:)
    @page = page
    @cid = cid
    @created_at = created_at
    @number = number
    @ipfs = ipfs
  end

  def url
    if current?
      "./#{@page.slug}.html"
    else
      ipfs.content(@cid).url
    end
  end

  def title = time

  def time = @created_at || Time.now.utc

  def meta_title = "Version #{@number}"

  def current?
    @page.history.current_version == self
  end
end
