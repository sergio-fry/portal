class PageLinkRegexp
  def match(str)
    m = str.match regexp
    puts [str, m].inspect
    m
  end

  def scan(str)
    str.scan(/\[\[(#{slug_regexp})?\|?#{text_regexp}\]\]/)
  end

  private

  def slug_regexp
    "[[:alnum:]\s]+"
  end

  def text_regexp
    "[[:alnum:]\s]+"
  end

  def regexp
    /\[\[(#{slug_regexp})?\|?(#{text_regexp})?\]\]/
  end
end
