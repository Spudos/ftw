FactoryBot.define do
  factory :fixture do
    sequence(:id) { 1 }
    sequence(:home) { 1 }
    sequence(:away) { 2 }
    sequence(:comp) { |n| n }
    sequence(:week_number) { |n| n }
  end
end
