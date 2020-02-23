FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    grader { false }
    admin { false }
    company { nil }
  end
end
