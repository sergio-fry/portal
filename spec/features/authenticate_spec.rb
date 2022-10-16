# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Authenticates", type: :feature do
  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }

  before { FactoryBot.create :page, slug: :main }
  # before { Capybara.current_driver = :selenium_chrome_headless }
  # after { Capybara.use_default_driver }

  it "requires auth to edit page" do
    visit "/pages/main/edit"

    expect(current_url).to match "users/sign_in"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "secret123"
    click_on "Log in"

    visit "/pages/main/edit"
    fill_in "Content", with: "some content"
    click_on "Update"

    visit "/pages/main"
    expect(page).to have_content "some content"
  end
end
