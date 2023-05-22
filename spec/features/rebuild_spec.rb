# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rebuild' do
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  let!(:user) { create(:user, email: 'admin@example.com', password: 'secret123') }

  before do
    sign_in user
    Page.new(:foo).source_content = 'content'
  end

  it 'can rebuild pages' do
    visit '/admin'

    assert_enqueued_jobs 0
    click_on 'Rebuild'
    assert_enqueued_jobs 1
    perform_enqueued_jobs
  end
end