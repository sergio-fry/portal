# frozen_string_literal: true

class Layout
  include Hanami::Helpers

  include Dependencies['ipfs.ipfs']

  def initialize(title:, ipfs:)
    @title = title
    @ipfs = ipfs
  end

  def wrap
    meta_title = @title
    wrapped_to_html(
      html do
        head do
          title meta_title
          meta name: :viewport, content: 'width=device-width,initial-scale=1'
          meta charset: 'UTF-8'
          meta build_time: Time.now.utc
          link href: theme_styles, rel: :stylesheet
        end
        body a: :auto do
          main class: 'page-content', 'aria-label': 'Content' do
            div class: :w do
              yield self
            end
          end
          script type: 'text/javascript', src: js_from_vendor('jquery-3.6.1.min.js')
          script type: 'text/javascript', src: js_from_vendor('opal/runtime.js')
          script type: 'text/javascript', src: embed_js_url
          script type: 'text/javascript' do
            raw(
              <<~SCRIPT
                <!-- Yandex.Metrika counter -->
                   (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
                   m[i].l=1*new Date();
                   for (var j = 0; j < document.scripts.length; j++) {if (document.scripts[j].src === r) { return; }}
                   k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
                   (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");
                   ym(95675134, "init", {
                        clickmap:true,
                        trackLinks:true,
                        accurateTrackBounce:true
                   });
                <!-- /Yandex.Metrika counter -->
              SCRIPT
            )
          end
        end
      end.to_s
    )
  end

  private

  def js_from_vendor(name)
    ipfs.new_content(
      Rails.root.join('vendor/javascript', name).read
    ).content.url(filename: 'script.js')
  end

  def embed_js_url
    ipfs.new_content(
      Opal.compile(
        Rails.root.join('app/javascript/embed.rb').read
      )
    ).content.url(filename: 'embed.js')
  end

  def theme_styles
    ipfs.new_content(
      Rails.root.join('app/assets/stylesheets/monospace.css').read
    ).content.url(filename: 'style.css')
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
