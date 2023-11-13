# frozen_string_literal: true

class PageLayout
  include Hanami::Helpers

  def initialize(content, page)
    @content = content
    @page = page
  end

  def to_s
    page = @page

    Layout.new(title: page.slug).wrap do |html|
      html.article do
        div class: 'post-meta' do
          strong "#{page.slug}.html"
          span '/'
          a 'Sergei O. Udalov', href: "./#{ENV.fetch('HOME_TITLE', 'home')}.html", class: 'title'
          br
          span updated_at.to_s
          br
          span 'ver. '
          a version, datetime: updated_at, title: 'History', href: '#', class: :history_link
          br
          a 'edit', title: 'Edit', href: "#{page_canonical_link}/edit", class: 'admin-tools', style: 'opacity: 0'
        end
        div class: :page_content do
          raw(content)
        end
        div class: :page_history, style: 'display: none' do
          raw(history)
        end
      end
    end
  end

  def updated_at
    @page.updated_at.utc
  end

  def history
    @page.history.to_s
  end

  private

  def version
    @page.history.current_version&.meta_title
  end

  attr_reader :content

  def page_canonical_link
    CanonicalLink.new(@page.slug).link
  end
end
