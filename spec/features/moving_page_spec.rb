require "rails_helper"

RSpec.feature "Moving page", type: :feature do
  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }

  let!(:target_page) { FactoryBot.create :page, slug: :politics }
  let!(:main_page) { FactoryBot.create :page, slug: :main }

  before { main_page.update_attribute :content, "Link to [[politics]]" }

  context "when target page is moved" do
    before { target_page.update_attribute :slug, :economics }

    it { expect(main_page.links).to be_present }
  end
end
