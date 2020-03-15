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
  validates :name, uniqueness: { scope: :company_id }

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, user)
      ad_media = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        ad_medium = user.company.ad_media.new
        ad_medium.attributes = row.to_hash.slice(*csv_attributes)
        ad_media << ad_medium
      end
      begin
        import!(ad_media, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        ad_media = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |ad_medium|
          csv << csv_attributes.map do |attr|
            ad_medium.send(attr)
          end
        end
      end
    end
  end
end
