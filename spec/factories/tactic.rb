FactoryBot.define do
  factory :tactic do
    sequence(:id) { |n| 1 + n }
    club_id { 1 }
    tactics { 1 }
    dfc_aggression { 6 }
    mid_aggression { 6 }
    att_aggression { 6 }
    press { 6 }
  end
end
