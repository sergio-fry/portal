class PageLinkRegexp
  def match(str)
    str.match regexp
  end

  def scan(str)
    str.scan(/(\[\[(#{slug_regexp})\|?(#{text_regexp})?\]\])/).map(&:first)
  end

  private

  def slug_regexp
    "[[:alnum:]\s_-]+"
  end

  def text_regexp
    slug_regexp
  end

  def regexp
    /\[\[(#{slug_regexp})\|?(#{text_regexp})?\]\]/
  end
end
