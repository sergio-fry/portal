# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Page history", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }
  before { sign_in user }

  let!(:moscow) { Page.new("article") }
  before { moscow.source_content = "I like Beatles" }

  it "links to moscow" do
    visit "/pages/article"

    expect(page).to have_content "I like Beatles"

    # NOTE click_on "edit" does not work because it uses
    # CanonicalLink to generate link with domain
    visit "/pages/article/edit"
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
