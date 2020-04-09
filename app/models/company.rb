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
class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :ad_media, dependent: :destroy
  has_many :indicators, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
end
