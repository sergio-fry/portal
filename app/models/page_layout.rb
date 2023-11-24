# frozen_string_literal: true

class PageLayout
  include Hanami::Helpers
  include Dependencies[:pages]

  def initialize(content, page, pages:)
    @content = content
    @page = page
    @pages = pages
  end

  def to_s
    page = @page

    Layout.new(title: page.slug).wrap do |html|
      html.article do
        div class: 'post-meta' do
          strong do
            a "#{page.slug}.html", href: canonical_link.link
          end

          span 'by'
          a 'Sergei O. Udalov', href: root_link, class: 'title'
          br
          span 'at'
          a updated_at.to_s, datetime: updated_at, title: 'History', href: '#', class: :history_link
          a 'edit', title: 'Edit', href: canonical_link.edit_link, class: 'admin-tools', style: 'opacity: 0'
          a 'new', title: 'New', href: new_page_link, class: 'admin-tools', style: 'opacity: 0'
          a 'admin', title: 'Admin', href: admin_link, class: 'admin-tools', style: 'opacity: 0'
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

  def canonical_link
    CanonicalLink.new(@page.slug)
  end

  def root_link = ENV.fetch('ROOT_URL')
  def new_page_link = URI.join(root_link, 'pages/new')
  def admin_link = URI.join(root_link, 'admin')
end
