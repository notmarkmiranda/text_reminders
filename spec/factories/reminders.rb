FactoryBot.define do
  factory :reminder do
    sequence(:text) { |n| "Do the dishes #{n}" }
    run_at { Time.now.tomorrow.in_time_zone("America/Denver") }
  end
end
