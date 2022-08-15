FactoryBot.define do
  factory :user do
    sequence(:phone_number) { |n| "+1303847#{n}" }
    verification { "0847" }
    verification_expiration { 15.minutes.from_now }
  end
end
