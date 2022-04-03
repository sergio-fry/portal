class PageLinkRegexp
  def match(str)
    str.match regexp
  end

  def regexp
    /\[\[([[:alnum:]]+)\|?([[:alnum:]]+)?\]\]/
  end

  def scan(str)
    str.scan /\[\[[[:alnum:]]+\|?[[:alnum:]]*\]\]/
  end
end
