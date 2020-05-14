# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators # 改善指標マスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(改善指標名)   :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_indicators_on_company_id  (company_id)
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
