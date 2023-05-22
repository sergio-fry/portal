# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessedContent do
  subject(:processed_content) { described_class.new content }

  context 'when content has link' do
    let(:content) { 'Text with link to [[page1]]' }

    it { expect(processed_content.to_s).to match(%r{Text with link to <a.*>page1</a>}) }
  end
end
