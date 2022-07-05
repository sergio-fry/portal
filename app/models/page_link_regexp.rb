class PageLinkRegexp
  def match(str)
    str.match regexp
  end

  def slug_regexp
    "[[:alnum:]\_\-]+"
  end

  def text_regexp
    "[[:alnum:]\s]+"
  end

  def regexp
    /\[\[(#{slug_regexp})\|?(#{text_regexp})?\]\]/
  end

  def scan(str)
    str.scan(/\[\[#{slug_regexp}\|?#{text_regexp}*\]\]/)
  end
end
