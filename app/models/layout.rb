class Layout
  include Hanami::Helpers

  def initialize(content)
    @content = content
  end

  def html
    wrapped_to_html(
      html do
        head do
          title page.title
          meta name: :viewport, content: "width=device-width,initial-scale=1"
        end
        body a: :auto do
          main class: "page-content", "aria-label": "Content" do
            div class: :w do
              a "..", href: "https://#{ENV.fetch("DOMAIN_NAME", "sergei.udalovs.ru")}"

              article do
                p class: "post-meta" do
                  time datetime: page.updated_at do
                    page.updated_at
                  end
                  br
                  span "Sergei O. Udalov"
                end
                div do
                  raw(content)
                end
              end
            end
          end
          link href: theme_styles, rel: :stylesheet
        end
      end.to_s
    )
  end

  private

  attr_reader :content

  def theme_styles
    IpfsFile.new(
      File.read(Rails.root.join("app/assets/stylesheets/monospace.css"))
    ).url(filename: "style.css")
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
