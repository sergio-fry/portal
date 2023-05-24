# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Moving page' do
  include Devise::Test::IntegrationHelpers

  let(:pages) { DependenciesContainer.resolve(:pages) }
  let(:moscow) { pages.find_aggregate('moscow') }
  let(:main) { pages.find_aggregate('main') }
  let(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }

  before do
    pages.create('moscow')
    pages.create('main')
  end

  context 'when pages linked' do
    before do
      sign_in user

      moscow.source_content = 'Moscow'
      pages.save_aggregate moscow
      main.source_content = 'Link to [[moscow|city]]'
      pages.save_aggregate main
    end

    context 'when target page is moved' do
      before do
        visit '/pages/moscow/edit'

        fill_in 'Slug', with: 'moscow_city'
        click_on 'Update'
      end

      it 'links to moscow' do
        visit '/pages/main'

        click_on 'city'

        expect(page).to have_content 'Moscow'
      end
    end
  end
end
