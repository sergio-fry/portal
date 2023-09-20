# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page history' do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }
  let(:features) { double(:features, history_enabled?: true) }

  before do
    Capybara.current_driver = :selenium_headless
    sign_in user
    Dependencies.container.stub(:features, features)
  end

  after do
    Dependencies.container.unstub :features
    Capybara.use_default_driver
  end

  context 'when page updated' do
    before do
      visit '/pages/new'
      fill_in 'Slug', with: 'article'
      fill_in 'Content', with: 'I like Beatles'
      click_on 'Create'

      visit '/pages/article/edit'
      fill_in 'Content', with: 'I like Queen'
      click_on 'Update'
    end

    example 'prev version could be found' do
      expect(page).not_to have_content 'I like Beatles'

      click_link_or_button 'History'
      click_link_or_button 'Version 1'

      expect(page).to have_content 'I like Beatles'
    end
  end
end
