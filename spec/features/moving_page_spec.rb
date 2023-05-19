# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Moving page' do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }
  let!(:moscow) { Page.new('moscow') }
  let!(:main) { Page.new('main') }

  before do
    sign_in user
    moscow.source_content = 'Moscow'
    main.source_content = 'Link to [[moscow|city]]'
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
