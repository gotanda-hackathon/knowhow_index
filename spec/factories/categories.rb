# frozen_string_literal: true

# == Schema Information
#
# Table name: categories # カテゴリマスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(カテゴリ名)   :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_categories_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "テストカテゴリ名#{n}" }
    association :company
  end
end
