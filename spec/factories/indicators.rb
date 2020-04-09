# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator # 改善指標マスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(改善指標名)       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_indicator_on_company_id           (company_id)
#  index_indicator_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
FactoryBot.define do
  factory :indicator do
    sequence(:name) { |n| "テスト媒体名#{n}" }
    association :company
  end
end
