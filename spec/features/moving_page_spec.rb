require "rails_helper"

RSpec.feature "Moving page", type: :feature do
  include Devise::Test::IntegrationHelpers

  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }
  before { sign_in user }

  let!(:moscow) { FactoryBot.create :page, slug: :moscow, content: "Here is Moscow" }
  let!(:main) { FactoryBot.create :page, slug: :main }

  before { main.update_attribute :content, "Link to [[moscow|Moscow]]" }

  context "when target page is moved" do
    before { moscow.reload }
    before { moscow.update_attribute :slug, :moscow_city }

    it "links to moscow" do
      visit "/pages/main"

      click_on "Moscow"

      expect(page).to have_content "Here is Moscow"
    end
  end
end
