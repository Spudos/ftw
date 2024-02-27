FactoryBot.define do
  factory :news do
    week { 1 }
    club_id { 1 }
    image { "MyString" }
    type { "" }
    headline { "MyString" }
    sub_headline { "MyString" }
    article { "MyString" }
  end
end
