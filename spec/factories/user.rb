FactoryBot.define do
  factory :user do
    fname { 'a' }
    lname { 'p' }
    email { 'test@email.com' }
    password { 'testpassword' }
    club { 0 }
  end
end
