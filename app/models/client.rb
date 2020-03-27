# frozen_string_literal: true

# == Schema Information
#
# Table name: clients # クライアントマスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(媒体名)       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_clients_on_company_id           (company_id)
#  index_clients_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Client < ApplicationRecord
  include CompanyMatchable
  belongs_to :company

  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :company_id }

  class << self
    def csv_attributes
      %w[name]
    end

    def csv_import!(file, user)
      clients = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        client = user.company.clients.new
        client.attributes = row.to_hash.slice(*csv_attributes)
        clients << client
      end
      begin
        import!(clients, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        clients = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |client|
          csv << csv_attributes.map do |attr|
            client.send(attr)
          end
        end
      end
    end
  end
end
