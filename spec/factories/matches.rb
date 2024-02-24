FactoryBot.define do
  factory :match do
    home_team { 1 }
    away_team { 2 }
    week_number { 1 }
    sequence(:match_id) { |n| "number+#{n}" }
  end
end
