require 'app/models/page_link_regexp'

RSpec.describe PageLinkRegexp do
  subject(:regexp) { described_class.new }

  it { expect(regexp.match("foo")).to be_falsey }
  it { expect(regexp.match("[[foo]]")).to be_truthy }
  it { expect(regexp.match("[[foo|Bar]]")).to be_truthy }
  it { expect(regexp.match("[[page1]]")).to be_truthy }
  it { expect(regexp.match("[[multi_word|Multi Word]]")).to be_truthy }
end
