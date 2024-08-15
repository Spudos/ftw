FactoryBot.define do
  factory :fixture do
    sequence(:id) { 1 }
    sequence(:home) { 1 }
    sequence(:away) { 2 }
    sequence(:comp) { 'Premier League' }
    sequence(:week_number) { 1 }
  end
end
