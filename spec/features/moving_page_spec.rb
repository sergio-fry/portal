require "rails_helper"

RSpec.feature "Moving page", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }
  before { sign_in user }

  let!(:moscow) { FactoryBot.create :page, slug: "moscow", content: "Here is Moscow" }
  let!(:main) { FactoryBot.create :page, slug: "main" }

  before { main.update_attribute :content, "Link to [[moscow|Moscow]]" }
  before { Capybara.current_driver = :selenium_chrome_headless }
  after { Capybara.use_default_driver }

  context "when target page is moved" do
    before { moscow.reload }
    before { moscow.update_attribute :slug, "moscow_city" }

    it "links to moscow" do
      visit "/pages/main"

      click_on "Moscow"

      expect(page).to have_content "Here is Moscow"
      expect(moscow.reload.linked_pages).to include main
    end
  end
end
