# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Moving page", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }
  before { sign_in user }

  let!(:moscow) { Page.new("moscow") }
  before { moscow.source_content = "Here is Moscow" }

  let!(:main) { Page.new("main") }
  before { main.source_content = "Link to [[moscow|Moscow]]" }

  context "when target page is moved" do
    before { moscow.move "moscow_city" }

    it "links to moscow" do
      visit "/pages/main"

      click_on "Moscow"

      expect(page).to have_content "Here is Moscow"
      expect(moscow.reload.linked_pages).to include main
    end
  end
end
