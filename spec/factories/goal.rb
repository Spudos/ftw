FactoryBot.define do
  factory :goal do
    sequence(:id) { |n| 1 + n }
    match_id { 1 }
    week_number { 1 }
    minute { 16 }
    assist_id { 100 }
    scorer_id { 100 }
    competition { "Premier League" }
  end
end
