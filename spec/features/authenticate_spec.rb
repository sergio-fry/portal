# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticates' do
  before do
    create(:user, email: 'admin@example.com', password: 'secret123')
    DependenciesContainer.resolve(:pages).create :main
  end

  context 'when not authenticated' do
    it 'prompts credentials' do
      visit '/pages/main/edit'
      expect(current_url).to match 'users/sign_in'
    end
  end

  context 'when authenticated' do
    before do
      visit '/users/sign_in'
      fill_in 'Email', with: 'admin@example.com'
      fill_in 'Password', with: 'secret123'
      click_on 'Log in'
    end

    it 'updates page' do
      visit '/pages/main/edit'
      fill_in 'Content', with: 'some content'
      click_on 'Update'
      expect(page).to have_content 'some content'
    end
  end
end
