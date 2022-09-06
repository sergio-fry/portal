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
        p class: 'post-meta' do
          a 'edit', datetime: updated_at, title: 'History', href: "./#{page.slug}/edit"
          br
          a updated_at, datetime: updated_at, title: 'History', href: "./#{page.slug}/history.html"
          br
          a 'Sergei O. Udalov', href: "./#{ENV.fetch('HOME_TITLE', 'home')}.html"
        end
        div do
          raw(content)
        end
      end
    end
  end

  def updated_at
    (@page.changed? ? Time.now : @page.updated_at).utc
  end

  private

  attr_reader :content

  def wrapped_to_html(content)
    <<~HTML
      <!DOCTYPE html>
      <html>
        #{content}
      </html>
    HTML
  end
end
