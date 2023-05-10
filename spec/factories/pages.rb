# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: "Boundaries::Database::Page" do
    sequence(:slug) { |n| "page-#{n}" }
    content { "content" }
  end
end
