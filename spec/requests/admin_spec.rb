require "rails_helper"

RSpec.describe "Admins", type: :request do
  include Devise::Test::IntegrationHelpers
  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }

  describe "GET /admin" do
    context "when guest" do
      before { get "/admin" }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "when admin" do
      before { sign_in user }
      before { get "/admin" }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
