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
          a page.updated_at, datetime: page.updated_at, title: "History", href: Ipfs::NewContent.new(page.history.to_s).url
          br
          a "Sergei O. Udalov", href: "https://#{ENV.fetch("DOMAIN_NAME", "sergei.udalovs.ru")}"
        end
        div do
          raw(content)
        end
      end
    end
  end

  private

  attr_reader :content

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
