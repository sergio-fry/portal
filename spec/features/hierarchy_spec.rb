RSpec.describe 'Hierarchy' do
  let(:page_a) { Page.new(:a) }
  let(:page_b) { Page.new(:b) }
  let(:page_c) { Page.new(:c) }

  context 'when have some links' do
    before do
      page_a.source_content = 'link to [[b]]'
      page_b.source_content = 'link to [[c]]'
    end

    xit 'should fail to add link to a' do
      expect do
        page_c.source_content = 'link to [[a]]'
      end.to raise_error(Page::CyclicLinksError)
    end
  end
end
