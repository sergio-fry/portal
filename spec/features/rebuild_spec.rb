# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rebuild' do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }
  let!(:page) { Page.new('foo') }

  before do
    sign_in user
  end

  context 'when target page is moved' do
    it 'links to moscow' do
      visit '/admin'

      click_on 'Rebuild'
      expect(page).to have_content 'Moscow'
    end
  end
end
