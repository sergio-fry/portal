# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController::Page do
  include Rails.application.routes.url_helpers

  subject(:page) { described_class.new page_object }

  let(:page_object) { Page.new 'main' }

  it { expect(subject.policy_class).to eq PagePolicy }

  describe '.to_model' do
    subject(:to_model) { page.to_model }

    it { expect(subject).to be_persisted }
  end

  describe 'page_url' do
    subject { page_url page, only_path: true }

    it { is_expected.to eq '/pages/main' }
  end
end
