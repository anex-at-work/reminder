# frozen_string_literal: true

FactoryBot.define do
  factory :reminder do
    association :user, factory: :user
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    time_at { Time.current.strftime('%H:%M') }
    date_at { Faker::Date.forward(20).strftime('%FT%T%:z') }
    user_date { nil }
    repeat_type { 'never' }

    trait :repeat_weekly do
      repeat_type { 'weekly' }
    end

    trait :repeat_monthly do
      repeat_type { 'monthly' }
    end

    trait :day_second do
      user_date { '2nd of month' }
    end

    trait :every_friday do
      user_date { 'every Friday' }
    end
  end
end
