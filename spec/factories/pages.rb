FactoryBot.define do
  factory :page, class: 'PageAggregate' do
    sequence(:slug) { |n| "slug#{n}" }
    updated_at { Time.now }

    initialize_with do
      new(
        id: nil,
        slug:,
        updated_at:
      )
    end

    to_create do |instance|
      DependenciesContainer.resolve(:pages).save_aggregate(
        instance
      )
    end
  end
end
