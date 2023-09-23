FactoryBot.define do
  factory :page, class: 'PageAggregate' do
    sequence(:id) { |id| id }
    sequence(:slug) { |n| "slug#{n}" }
    updated_at { Time.now }

    initialize_with do
      new(
        id:,
        slug:,
        updated_at:
      )
    end
  end
end
