# frozen_string_literal: true

# This code is used inside IPFS pages

require "native"

class JQuery
  def onload(&block)
    `jQuery(document).ready(block)`
  end

  def [](selector)
    Native::Array.new `jQuery(selector)`
  end
end

class Store
  def initialize
    @state = {}
    @listeners = []
  end

  def subscribe(listener)
    @listeners << listener
  end

  def state
    @state.clone
  end
end

class Link
  def initialize(el, state:)
    @el = el
    @state = state
  end

  def render
    if target_available?
      @el.attr(:href, link)
    else
      @el.attr(:href, canonical_link)
    end
  end

  def target_available?
    @state.dig(:remote_links, link) == "available"
  end

  def link
    @el.data("link")
  end

  def canonical_link
    @el.data("canonical-link")
  end
end

class Page
  def initialize(jquery:, store:)
    @jquery = jquery
    @store = store
  end

  def render
    links.each(&:render)
  end

  def links
    @jquery[".link"].map do |el|
      Link.new $$.jQuery(el), state: @store.state
    end
  end
end

jquery = JQuery.new
store = Store.new

page = Page.new(jquery: jquery, store: store)
store.subscribe { page.render }

jquery.onload do
  page.render
end
