# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessedContent do
  subject { described_class.new page }
  let(:page) { Page.new :main }
  before { page.content = content }

  context do
    let(:content) { "Text with link to [[page1]]" }

    it { expect(subject.to_s).to match(%r{Text with link to <a.*>page1</a>}) }
  end
end
