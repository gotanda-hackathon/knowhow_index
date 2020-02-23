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
class Company < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
end
