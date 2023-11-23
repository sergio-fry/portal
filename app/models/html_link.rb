# frozen_string_literal: true

require 'delegate'

class HtmlLink < SimpleDelegator
  def html
    result = ''

    result += <<~HTML
      <a href='#{__getobj__.link}'
        class='#{__getobj__.css_classes}'
        data-link='#{__getobj__.link}'
        data-canonical-link='#{__getobj__.canonical.link}'>#{__getobj__.name}></a>
    HTML

    result
  end
end
