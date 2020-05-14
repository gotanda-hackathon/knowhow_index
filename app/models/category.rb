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
#  index_categories_on_company_id           (company_id)
#  index_categories_on_name_and_company_id  (name,company_id) UNIQUE
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

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, user)
      categories = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        category = user.company.categories.new
        category.attributes = row.to_hash.slice(*csv_attributes)
        categories << category
      end
      begin
        import!(categories, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        categories = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |category|
          csv << csv_attributes.map do |attr|
            category.send(attr)
          end
        end
      end
    end
  end
end
