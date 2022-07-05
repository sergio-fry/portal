FactoryBot.define do
  factory :user do
    email { 'user1@example.com' }
    password { 'secret123' }
    password_confirmation { password }
  end
end

