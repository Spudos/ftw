FactoryBot.define do
  factory :performance do
    sequence(:id) { |n| 1 + n }
    match_id { 1 }
    player_id { 1 }
    club_id { 1 }
    name { "Woolley" }
    match_performance { 50 }
    competition { "Premier League" }
  end
end
