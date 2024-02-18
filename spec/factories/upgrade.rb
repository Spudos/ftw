FactoryBot.define do
  factory :upgrade do
    week { 1 }
    club { 1 }
    var1 { 'test' }
    var2 { nil }
    var3 { 0 }
    action_id { 'test' }
  end
end