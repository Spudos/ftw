FactoryBot.define do
  factory :player do
    position { 'gkp' }
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
  end
end
