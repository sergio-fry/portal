require "kramdown"

class ProcessedContent
  include Hanami::Helpers

  def initialize(page)
    @page = page
  end

  def to_s
    with_layout(
      with_page_links(
        converted_to_html(
          @page.content.to_s
        )
      )
    )
  end

  private

  attr_reader :page

  def with_layout(content)
    wrapped_to_html(
      html do
        head do
          title page.title
          meta name: :viewport, content: "width=device-width,initial-scale=1"
          style theme_styles
        end
        body a: :auto do
          main class: "page-content", "aria-label": "Content" do
            div class: :w do
              raw(content)
            end
          end
        end
      end.to_s
    )
  end

  def theme_styles
    ""
  end

  def wrapped_to_html(content)
    <<~HTML
      <!DOCTYPE html>
      <html>
        #{content}
      </html>
    HTML
  end

  def converted_to_html(content)
    Kramdown::Document.new(content).to_html
  end

  def with_page_links(content)
    content = content.dup

    page_link_tags(content).each do |link|
      content.gsub!(link.markup, link.html)
    end

    content
  end

  def page_link_tags(content)
    PageLinkRegexp.new.scan(content).flatten.uniq.map do |markup|
      PageLink.new(markup, @page)
    end
  end
end
