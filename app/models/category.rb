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
class Category < ApplicationRecord
  include CompanyMatchable

  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :company_id }
end
