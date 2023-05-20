# frozen_string_literal: true

require 'ruby-prof'

result = RubyProf::Profile.profile do
  Sitemap.new.page_url(Page.new('main'))
end

# print a graph profile to text
# printer = RubyProf::GraphPrinter.new(result)
printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print($stdout, {})
