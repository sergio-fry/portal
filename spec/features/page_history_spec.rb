# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page history' do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }
  let!(:moscow) { Page.new('article') }

  before do
    sign_in user
    moscow.source_content = 'I like Beatles'
  end

  it 'links to moscow' do
    visit '/pages/article'

    expect(page).to have_content 'I like Beatles'

    visit '/pages/article/edit'
    fill_in 'Content', with: 'I like Queen'
    click_on 'Update'

    expect(page).not_to have_content 'I like Beatles'

    click_link_or_button 'History'

    click_link_or_button 'Version 1'

    expect(page).to have_content 'I like Beatles'
  end
end
