# frozen_string_literal: true

# This code is used inside IPFS pages

require 'native'

# rubocop:disable Style/SpecialGlobalVars

class JQuery
  def onload(&block) # rubocop:disable Lint/UnusedMethodArgument, Naming/BlockForwarding
    `jQuery(document).ready(block)`
  end

  def [](selector) # rubocop:disable Lint/UnusedMethodArgument
    Native::Array.new `jQuery(selector)`
  end

  def find(selector)
    `$(#{selector})`
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
  def initialize(element, state:)
    @element = element
    @state = state
  end

  def render
    # no op
  end

  def link
    @el.data('link')
  end

  def canonical_link
    @el.data('canonical-link')
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
    render_content
  end

  def render_content
    case @state[:page_mode]
    when :content
      `$('.page_content').show()`
      `$('.page_history').hide()`
    when :history
      `$('.page_content').hide()`
      `$('.page_history').show()`
    end
  end

  def links
    @jquery['.link'].map do |el|
      Link.new $$.jQuery(el), state: @state
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
    $$.jQuery('.admin-tools').css(opacity: 0.0)
  end

  def disaply_admin_tools
    $$.jQuery('.admin-tools').css(opacity: 1)
  end

  def admin?
    @state[:is_admin] == 'true'
  end

  def update_url
    return unless @state.dig(:remote_links, ipfs_page_url) == 'available'

    $$.window.location.href = ipfs_page_url
  end

  def ipfs_page_url
    $$.jQuery('.ipfs-page').data('ipfs-url')
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

    @store.dispatch lambda { |state|
      state[:remote_links][link] = 'loading'

      state
    }

    promise = Native(`jQuery.ajax(link)`)

    promise.done lambda {
      mark_link_as_available link
    }
  end

  def mark_link_as_available(link)
    @store.dispatch lambda { |state|
      state[:remote_links] ||= {}
      state[:remote_links][link] = 'available'

      state
    }
  end

  def available?(link)
    @store.state.dig(:remote_links, link) == 'available'
  end
end

jquery = JQuery.new
store = Store.new(
  remote_links: {},
  page_mode: :content
)

store.subscribe lambda { |state|
  Page.new(state).render
}

jquery.onload do
  store.dispatch(->(state) { state })

  RemoteLinks.new(Page.new(store.state).ipfs_links, store:).update

  Native(`$('.history_link')`).on('click', lambda {
    store.dispatch lambda { |state|
      state[:page_mode] = state[:page_mode] == :content ? :history : :content

      state
    }

    `return false`
  })
end

# rubocop:enable Style/SpecialGlobalVars
