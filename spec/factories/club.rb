FactoryBot.define do
  factory :club do
    sequence(:name) { |n| "Team #{n}" }
    stand_n_capacity { 0 }
    stand_s_capacity { 0 }
    stand_e_capacity { 0 }
    stand_w_capacity { 0 }
    stand_n_condition { 0 }
    stand_s_condition { 0 }
    stand_e_condition { 0 }
    stand_w_condition { 0 }
    facilities { 0 }
    hospitality { 0 }
    pitch { 0 }
    staff_gkp { 0 }
    staff_dfc { 0 }
    staff_mid { 0 }
    staff_att { 0 }
    staff_fitness { 0 }
    staff_scouts { 0 }
    fanbase { 0 }
    fan_happiness { 0 }
    ticket_price { 0 }
  end
end
