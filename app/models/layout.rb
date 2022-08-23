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
