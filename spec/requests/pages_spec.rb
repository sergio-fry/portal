# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages", type: :request do
  include Devise::Test::IntegrationHelpers
  let!(:user) { FactoryBot.create :user, email: "admin@example.com", password: "secret123" }

  let!(:page) { Page.new :main }
  before { page.content = "content" }

  describe "GET pages/:id" do
    context "when guest" do
      before { get "/pages/main" }
      it { expect(response).to have_http_status(:success) }
    end

    context "when admin" do
      before { sign_in user }
      before { get "/pages/main" }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
