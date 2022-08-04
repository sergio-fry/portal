require "app/models/page_link_regexp"

RSpec.describe PageLinkRegexp do
  subject(:regexp) { described_class.new }

  describe "#match" do
    it { expect(regexp.match("foo")).to be_falsey }
    it { expect(regexp.match("[[foo]]")).to be_truthy }
    it { expect(regexp.match("[[foo|Bar]]")).to be_truthy }
    it { expect(regexp.match("[[with_undercore|Bar]]")).to be_truthy }
    it { expect(regexp.match("[[with-minus|Bar]]")).to be_truthy }
    it { expect(regexp.match("[[page1]]")).to be_truthy }
    it { expect(regexp.match("[[slug|Multi Word]]")).to be_truthy }
    it { expect(regexp.match("[[multi word slug|Text]]")).to be_truthy }
    it { expect(regexp.match("[[Multi Word]]")).to be_truthy }
  end

  describe "#scan" do
    subject { regexp.scan(text).to_a }

    context do
      let(:text) { "Text with link [[page1]]." }
      it { is_expected.to include "[[page1]]" }
    end
  end
end
