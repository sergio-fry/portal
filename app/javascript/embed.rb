# frozen_string_literal: true

# This code is used inside IPFS pages

require 'native'

class JQuery
  def onload(&block)
    %x{
      jQuery(document).ready(block);
    }
  end

  def [](selector)
    Native::Array.new `jQuery(selector)`
  end
end

class Store
  def initialize
    @data = {}
    @listeners = []
  end

  def subscribe(listener)
    @listeners << listener
  end
end

class Link
  def initialize(el)
    @el = el
  end
end

class Page
end

store = Store.new

page = Page.new
store.subscribe { page.render }

jquery = JQuery.new

jquery.onload do
  jquery[".link"].map do |el|
    Link.new el
  end
end
