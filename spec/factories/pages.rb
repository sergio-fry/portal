# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: "Boundaries::Database::Page" do
    slug { "slug" }
    content { "content" }
  end
end
