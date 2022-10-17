# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "Boundaries::Database::User" do
    email { "user1@example.com" }
    password { "secret123" }
    password_confirmation { password }
  end
end
