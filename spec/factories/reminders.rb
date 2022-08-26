FactoryBot.define do
  factory :reminder do
    sequence(:text) { |n| "This is from a test file. #{n}" }
    run_at { Time.now.tomorrow.in_time_zone("America/Denver") }
    user
  end
end
