FactoryBot.define do
  factory :page, class: 'PageAggregate' do
    id { nil }
    sequence(:slug) { |n| "slug#{n}" }
    updated_at { Time.now }

    trait :persisted do
      sequence(:id) { |id| id }
    end

    initialize_with do
      new(
        id:,
        slug:,
        updated_at:
      )
    end

    to_create do |instance|
      pages = DependenciesContainer.resolve(:pages)
      pages.save_aggregate(
        instance
      )
    end
  end
end
