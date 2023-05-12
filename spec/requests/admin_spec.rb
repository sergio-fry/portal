# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins' do
  include Devise::Test::IntegrationHelpers
  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }

  describe 'GET /admin' do
    context 'when guest' do
      before { get '/admin' }

      it { expect(response).to have_http_status(:redirect) }
    end

    context 'when admin' do
      before do
        sign_in user
        get '/admin'
      end

      it { expect(response).to have_http_status(:success) }
    end
  end
end
