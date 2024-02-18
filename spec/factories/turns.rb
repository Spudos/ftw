FactoryBot.define do
  factory :turn do
    week { 1 }
    club { 1 }
    var1 { 'var1' }
    var2 { nil }
    var3 { 0 }
    date_completed { DateTime.now }
  end
end
