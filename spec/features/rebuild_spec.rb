# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rebuild' do
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  let!(:user) { create(:user, email: 'user@example.com', password: 'secret123') }
  let(:pages) { DependenciesContainer.resolve(:pages) }

  before do
    sign_in user
    page = create(:page, slug: :foo)
    pages.save_aggregate page
  end

  it 'can rebuild pages' do
    visit '/admin'

    assert_enqueued_with(job: RebuildPageJob) do
      click_on 'Rebuild'
    end

    perform_enqueued_jobs
  end
end
