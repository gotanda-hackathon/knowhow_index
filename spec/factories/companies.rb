# frozen_string_literal: true

# == Schema Information
#
# Table name: companies # 利用企業テーブル
#
#  id           :bigint           not null, primary key
#  name(企業名) :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_companies_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "テスト企業#{n}" }
  end
end
