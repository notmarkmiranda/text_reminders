FactoryBot.define do
  factory :user do
    sequence(:phone_number) { |n| n.to_s.rjust(10, '0') }
    verification { "0847" }
    verification_expiration { 15.minutes.from_now }
    timezone { nil }
  end
end
