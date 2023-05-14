# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Moving page' do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }
  let!(:moscow) { Page.new('moscow') }
  let!(:main) { Page.new('main') }

  before do
    sign_in user
    moscow.source_content = 'Here is Moscow'
    main.source_content = 'Link to [[moscow|Moscow]]'
  end

  context 'when target page is moved' do
    before { moscow.move 'moscow_city' }

    it 'links to moscow' do
      visit '/pages/main'

      click_on 'Moscow'

      expect(page).to have_content 'Here is Moscow'
      expect(moscow.linked_pages).to include main
    end
  end
end
