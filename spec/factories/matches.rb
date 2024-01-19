FactoryBot.define do
  factory :match do
    home_team { '001' }
    away_team { '002' }
    sequence(:match_id) { |n| "number+#{n}" }
  end
end
