require "rails_helper"

RSpec.feature "Authenticates", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }

  it "requires auth to edit page" do
    visit "/pages/main/edit"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "secret123"
    click_on "Log in"
  end
end
