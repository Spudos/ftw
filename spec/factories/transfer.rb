FactoryBot.define do
  factory :transfer do
    sequence(:id) { |n| 1 + n }
    player_id { 1 }
    sell_club { 1 }
    buy_club { 2 }
    week { 1 }
    bid { 10000000 }
    status { 'bid' }
  end
end
