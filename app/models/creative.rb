# frozen_string_literal: true

# == Schema Information
#
# Table name: creatives # クリエイティブテーブル
#
#  id                 :bigint           not null, primary key
#  name(企業名)       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :integer          not null
#
class Creative < ApplicationRecord
  include CompanyMatchable

  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :company_id }

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, creative)
      creatives = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        creatives = creative.company.creatives.new
        creative.attributes = row.to_hash.slice(*csv_attributes)
        creatives << creative
      end
      begin
        import!(creative, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        creatives = []
        retry
      end
    end

    def generate_csv_by(creative)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(creative).find_each do |creative|
          csv << csv_attributes.map do |attr|
            creative.send(attr)
          end
        end
      end
    end
  end
end
