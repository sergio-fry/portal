# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticates' do
  let(:pages) { DependenciesContainer.resolve(:pages) }

  before do
    create(:user, email: 'user@example.com', password: 'secret123')
    pages.create :home
  end

  context 'when not authenticated' do
    it 'prompts credentials' do
      visit '/pages/home/edit'
      expect(current_url).to match 'users/sign_in'
    end
  end

  context 'when authenticated' do
    before do
      visit '/users/sign_in'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'secret123'
      click_on 'Log in'
    end

    it 'updates page' do
      visit '/pages/home/edit'
      fill_in 'Slug', with: 'new_page'
      fill_in 'Content', with: 'some content'
      click_on 'Update page'
      expect(page).to have_content 'some content'
    end
  end
end
