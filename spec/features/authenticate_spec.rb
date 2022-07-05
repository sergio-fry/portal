require 'rails_helper'

RSpec.feature "Authenticates", type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.new }

  it "requires auth to edit page" do
    visit '/pages/main/edit'

    fill_in 'email', with: 'admin@example.com'
    fill_in 'password', with: 'secret123'
    click_on 'sign in'
  end
end
