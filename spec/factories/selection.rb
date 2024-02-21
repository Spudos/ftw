FactoryBot.define do
  factory :selection do
    sequence(:id) { |n| 1 + n }
    club_id { 1 }
    player_id { 1 }
  end
end
