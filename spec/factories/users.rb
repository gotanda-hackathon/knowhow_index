# frozen_string_literal: true

# == Schema Information
#
# Table name: users # ユーザーテーブル
#
#  id                          :bigint           not null, primary key
#  administrator(管理者フラグ) :boolean          default("false"), not null
#  email(メールアドレス)       :string           not null
#  grader(採点者フラグ)        :boolean          default("false"), not null
#  name(氏名)                  :string           not null
#  password_digest(パスワード) :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  company_id(企業ID)          :bigint           not null
#
# Indexes
#
#  index_users_on_company_id  (company_id)
#  index_users_on_email       (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "テストユーザー#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'test1234' }
    association :company
    grader { [true, false].sample }
    administrator { [true, false].sample }

    trait :normal do
      grader { false }
      administrator { false }
    end

    trait :not_grader do
      grader { false }
      administrator { false }
    end

    trait :grader do
      grader { true }
      administrator { false }
    end

    trait :not_administrator do
      grader { false }
      administrator { false }
    end

    trait :administrator do
      grader { false }
      administrator { true }
    end
  end
end
