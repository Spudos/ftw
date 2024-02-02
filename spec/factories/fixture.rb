FactoryBot.define do
  factory :fixture do
    sequence(:id) { 1 }
    sequence(:home) { '001' }
    sequence(:away) { '002' }
    sequence(:comp) { |n| n }
    sequence(:week_number) { |n| n }
  end
end
