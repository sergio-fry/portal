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
  def initialize(state = {})
    @state = state
    @listeners = []
  end

  def subscribe(listener)
    @listeners << listener
  end

  def state
    @state.clone
  end

  def dispatch(reducer)
    update_state_with reducer.call(state)
    awake_listeners
  end

  private

  def update_state_with(new_state)
    @state = new_state
  end

  def awake_listeners
    current = state
    @listeners.each { |listener| listener.call(current) }
  end
end

class Link
  def initialize(el:, state:)
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
    puts @state.inspect
    # TODO: update state with request
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
  def initialize(state)
    @jquery = JQuery.new
    @state = state
  end

  def render
    links.each(&:render)
    render_admin_tools
    update_url
  end

  def links
    @jquery[".link"].map do |el|
      Link.new el: $$.jQuery(el), state: @state
    end
  end

  def render_admin_tools
    if admin?
      disaply_admin_tools
    else
      hide_admin_tools
    end
  end

  def hide_admin_tools
    $$.jQuery(".admin-tools").css(opacity: 0.1)
  end

  def disaply_admin_tools
    $$.jQuery(".admin-tools").css(opacity: 1)
  end

  def admin?
    @state.dig(:is_admin) == "true"
  end

  def update_url
    if @state.dig(:remote_links, ipfs_page_url) == "available"
      $$.window.location.href = ipfs_page_url
    end
  end

  def ipfs_page_url
    $$.jQuery(".ipfs-page").data("ipfs-url")
  end

  def ipfs_links
    [ipfs_page_url]
  end
end

class RemoteLinks
  def initialize(links, store:)
    @links = links
    @store = store
  end

  def update
    @links.compact.each { |link| check_link link }
  end

  def check_link(link)
    return if available?(link)

    @store.dispatch ->(state) {
      state[:remote_links][link] = "loading"

      state
    }

    promise = Native(`jQuery.ajax(link)`)

    promise.done -> {
      mark_link_as_available link
    }
  end

  def mark_link_as_available(link)
    @store.dispatch ->(state) {
      state[:remote_links] ||= {}
      state[:remote_links][link] = "available"

      state
    }
  end

  def available?(link)
    @store.state.dig(:remote_links, link) == "available"
  end
end

jquery = JQuery.new
store = Store.new(
  remote_links: {}
)

store.subscribe ->(state) {
  Page.new(state).render
}

jquery.onload do
  store.dispatch(->(state) { state })

  RemoteLinks.new(Page.new(store.state).ipfs_links, store: store).update
end
