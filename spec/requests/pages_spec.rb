# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', skip: true do
  include Devise::Test::IntegrationHelpers
  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }

  let!(:page) { Page.new :main }

  before { page.source_content = 'content' }

  describe 'GET pages/:id' do
    context 'when guest' do
      before { get '/pages/main' }

      it { expect(response).to have_http_status(:success) }
    end

    context 'when admin' do
      before do
        sign_in user
        get '/pages/main'
      end

      it { expect(response).to have_http_status(:success) }
    end
  end
end
