FactoryBot.define do
  factory :match do
    home_team { 1 }
    away_team { 2 }
    week_number { 1 }
    sequence(:match_id) { |n| "number+#{n}" }
    attendance { 10_000 }
  end
end
