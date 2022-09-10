# frozen_string_literal: true

class Layout
  include Hanami::Helpers

  def initialize(title:)
    @title = title
  end

  def wrap
    meta_title = @title
    wrapped_to_html(
      html do
        head do
          title meta_title
          meta name: :viewport, content: "width=device-width,initial-scale=1"
          meta charset: "UTF-8"
          meta build_time: Time.now.utc
          link href: theme_styles, rel: :stylesheet
          script type: "text/javascript", src: js_from_vendor("jquery-3.6.1.min.js")
          script type: "text/javascript", src: js_from_vendor("opal-1.5.1/opal.min.js")
          script type: "text/javascript", src: js_from_vendor("opal-1.5.1/native.min.js")
          script type: "text/javascript", src: embed_js_url
        end
        body a: :auto do
          main class: "page-content", "aria-label": "Content" do
            div class: :w do
              yield self
            end
          end
        end
      end.to_s
    )
  end

  private

  def js_from_vendor(name)
    Ipfs::NewContent.new(
      File.read(Rails.root.join("vendor/javascript", name))
    ).content.url(filename: "script.js")
  end

  def embed_js_url
    Ipfs::NewContent.new(
      Opal.compile(
        File.read(Rails.root.join("app/javascript/embed.rb"))
      )
    ).content.url(filename: "embed.js")
  end

  def theme_styles
    Ipfs::NewContent.new(
      File.read(Rails.root.join("app/assets/stylesheets/monospace.css"))
    ).content.url(filename: "style.css")
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
