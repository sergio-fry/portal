# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessedContent do
  let(:pages) { [] }
  def processed_content(content) = described_class.new(content, pages:).to_s

  context 'when content has link' do
    it {
      expect(
        processed_content('Text with link to [[page1]]')
      ).to match(%r{Text with link to <a.*>page1</a>})
    }
  end

  context 'sitemap' do
    let(:pages) { [page] }
    let(:page) { double(:page, slug: 'moscow', updated_at: Time.now) }

    it {
      expect(
        processed_content('<sitemap />')
      ).to match(/<a.*>moscow<\/a>/)
    }
  end
end
