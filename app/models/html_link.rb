# frozen_string_literal: true

require 'delegate'

class HtmlLink
  def html
    result = ''

    result += "<a href='#{__getobj__.link}' class='#{__getobj__.css_classes}' data-link='#{__getobj__.link}' data-canonical-link='#{__getobj__.canonical}'>#{__getobj__.name}</a>"

    result
  end
end
