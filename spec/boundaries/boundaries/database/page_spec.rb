# frozen_string_literal: true

require 'rails_helper'

module Boundaries
  module Database
    RSpec.describe Page, type: :model do
      let(:default_attrs) { { content: 'content' } }

      def new_page(attrs)
        Page.new default_attrs.merge(attrs)
      end

      def save_page = new_page(slug: 'foo').save!

      it { expect { save_page }.to change(described_class, :count).by(1) }
    end
  end
end
