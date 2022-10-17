# frozen_string_literal: true

require "rails_helper"

module Boundaries
  module Database
    RSpec.describe Page, type: :model do
      let(:default_attrs) { { content: "content" } }

      def new_page(attrs)
        Page.new default_attrs.merge(attrs)
      end

      describe "slug validation" do
        it { expect(new_page(slug: "politics")).to be_valid }
        it { expect(new_page(slug: "Politics")).not_to be_valid }
        it { expect(new_page(slug: "история")).to be_valid }
      end
    end
  end
end
