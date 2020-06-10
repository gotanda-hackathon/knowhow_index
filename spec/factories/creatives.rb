# frozen_string_literal: true

# == Schema Information
#
# Table name: creatives # クリエイティブマスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(クリエイティブ名)       :string           not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_creatives_on_company_id           (company_id)
#  index_creatives_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
FactoryBot.define do
  factory :creatives do
    sequence(:name) { |n| "テストクリエイティブ名#{n}" }
    association :company
  end
end
