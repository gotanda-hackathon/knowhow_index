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
class Indicator < ApplicationRecord
  include CompanyMatchable

  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :company_id }

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, user)
      indicator = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        indicator = user.company.indicator.new
        indicator.attributes = row.to_hash.slice(*csv_attributes)
        indicator << indicator
      end
      begin
        import!(indicator, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        indicator = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |indicator|
          csv << csv_attributes.map do |attr|
            indicator.send(attr)
          end
        end
      end
    end
  end
end
