# frozen_string_literal: true

# == Schema Information
#
# Table name: creative # クリエイティブテーブル
#
#  id                 :bigint           not null, primary key
#  name(企業名)       :string           not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_creative_on_company_id           (company_id)
#  index_creative_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class creative < ApplicationRecord
  include CompanyMatchable

  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :company_id }

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, user)
      creative = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        creative = user.company.creative.new
        creative.attributes = row.to_hash.slice(*csv_attributes)
        creative << creative
      end
      begin
        import!(creative, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        creative = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |creative|
          csv << csv_attributes.map do |attr|
            creative.send(attr)
          end
        end
      end
    end
  end
end
