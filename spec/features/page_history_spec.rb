require "rails_helper"

RSpec.feature "Page history", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }
  before { sign_in user }

  let!(:moscow) { FactoryBot.create :page, slug: "article", content: "I like Beatles" }

  it "links to moscow" do
    visit "/pages/article"

    expect(page).to have_content "I like Beatles"

    click_on "edit"
    fill_in "Content", with: "I like Queen"
    click_on "Update"

    expect(page).not_to have_content "I like Beatles"

    click_link_or_button "History"

    skip do
      click_link_or_button "Version 1"

      expect(page).to have_content "I like Beatles"
    end
  end
end