# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do
      Faker::Internet.safe_email
    end

    after :build do |user|
      user.password = user.password_confirmation = Faker::Internet.password
    end
  end
end
