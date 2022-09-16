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
        p class: "post-meta" do
          a "Sergei O. Udalov", href: "./#{ENV.fetch("HOME_TITLE", "home")}.html", class: "title"
          span "/"
          strong "#{page.slug}.html"
          br
          span updated_at.to_s
          br
          span "ver. "
          a version, datetime: updated_at, title: "History", href: "#{page.slug}/history.html"
          br
          a "edit", title: "Edit", href: "#{page_canonical_link}/edit", class: "admin-tools"
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

  def version
    @page.history.versions.map(&:number).max
  end

  attr_reader :content

  def page_canonical_link
    CanonicalLink.new(@page.slug).link
  end

  def wrapped_to_html(content)
    <<~HTML
      <!DOCTYPE html>
      <html>
        #{content}
      </html>
    HTML
  end
end
