FactoryBot.define do
  factory :player do
    sequence(:id) { |n| 401 + n }
    name { 'Woolley' }
    position { 'gkp' }
    club_id { 1 }
    passing { 5 }
    control { 5 }
    tackling { 5 }
    running { 5 }
    shooting { 5 }
    dribbling { 5 }
    defensive_heading { 5 }
    offensive_heading { 5 }
    flair { 5 }
    strength { 5 }
    creativity { 5 }
    fitness { 90 }
    consistency { 10 }
    player_position_detail { 'p' }
    star { 5 }
    potential_tackling { 10 }
    wages { 100 }
    total_skill { 85 }
    available { 0 }
  end
end
