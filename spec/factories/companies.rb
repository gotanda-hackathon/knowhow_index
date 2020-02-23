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
FactoryBot.define do
  factory :company do
    name { 'MyString' }
  end
end
