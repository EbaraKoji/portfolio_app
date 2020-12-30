FactoryBot.define do
  factory :problem do
    sequence(:title) { |n| "title#{n}" }
    sequence(:content) { |n| "content#{n}" }
    created_at { 2.week.ago }
    updated_at { 1.week.ago }
    association :user

    # trait :latest_problem do
    #   created_at { Time.now }
    # end

    # trait :first_problem do
    #   created_at { 5.years.ago }
    # end
  end
end
