# frozen_string_literal: true

# == Schema Information
#
# Table name: ad_media # 広告媒体マスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(媒体名)       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_ad_media_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class AdMedium < ApplicationRecord
  include CompanyMatchable

  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validate :name_must_not_be_duplicated_within_same_company

  def name_must_not_be_duplicated_within_same_company
    errors.add :name, 'はすでに存在しています' if AdMedium.where(company: company).pluck(:name).any? { |n| n.include?(name) }
  end
end
