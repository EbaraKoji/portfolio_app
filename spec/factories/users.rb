FactoryBot.define do

  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:name) { |n| "Username#{n}" }
    sequence(:password) { |n| "password#{n}" }
  end

end