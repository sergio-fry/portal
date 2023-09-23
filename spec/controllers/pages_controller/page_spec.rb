# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController::Page do
  include ActionView::Helpers::UrlHelper
  include ActionController::UrlFor
  include Rails.application.routes.url_helpers

  subject(:page) { described_class.new page_object, context: }

  let(:context) { double(:context) }

  let(:page_object) { build(:page, slug: 'main') }

  it { expect(page.policy_class).to eq PagePolicy }

  describe '.to_model' do
    subject(:to_model) { page.to_model }

    it { expect(to_model).to be_persisted }
  end

  describe 'page_url' do
    subject { page_url page, only_path: true }

    it { is_expected.to eq '/pages/main' }
  end

  describe 'link_to' do
    subject { link_to 'show', page }

    it { is_expected.to include '/pages/main' }
  end
end
