FactoryBot.define do
  factory :club do
    sequence(:abbreviation) { '001' }
    sequence(:name) { |n| "Team #{n}" }
    sequence(:stand_n_capacity) { |n| n }
    sequence(:stand_s_capacity) { |n| n }
    sequence(:stand_e_capacity) { |n| n }
    sequence(:stand_w_capacity) { |n| n }
  end
end