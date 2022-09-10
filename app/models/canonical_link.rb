class CanonicalLink
  def initialize(link)
    @link = link
  end

  def link
    URI.join(
      ENV.fetch("ROOT_URL"),
      "/pages/"
    ).to_s + @link.to_s
  end
end
