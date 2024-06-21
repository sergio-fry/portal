require 'rails_helper'

RSpec.describe 'Create missing pages', pending: 'todo' do
  let(:page_a) { Page.new(:a) }

  context 'when link to missing page' do
    before do
      page_a.source_content = 'link to [[b]]'
    end

    it { expect(page_a.links).to include [1] }
  end
end
