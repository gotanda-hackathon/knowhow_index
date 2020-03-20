# frozen_string_literal: true

# == Schema Information
#
# Table name: users # ユーザーテーブル
#
#  id                          :bigint           not null, primary key
#  administrator(管理者フラグ)         :boolean          default("false"), not null
#  email(メールアドレス)       :string           not null
#  grader(採点者フラグ)        :boolean          default("false"), not null
#  name(氏名)                  :string           not null
#  password_digest(パスワード) :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  company_id(企業ID)          :bigint           not null
#
# Indexes
#
#  index_users_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class User < ApplicationRecord
  include CompanyMatchable

  belongs_to :company
  has_many :sql_conditions, dependent: :destroy

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :company_id, presence: true

  has_secure_password

  def get_search_condition(code:, params:)
    sql_condition = sql_conditions.find_or_initialize_by(code: code)
    sql_condition.condition = YAML.dump(params.with_indifferent_access) unless params.empty?
    sql_condition.save!

    if sql_condition.condition
      Psych.safe_load(sql_condition.condition, [ActiveSupport::HashWithIndifferentAccess])
    else
      {}
    end
  end

  class << self
    def csv_attributes
      %w[name email password password_confirmation company_id administrator grader]
    end

    def csv_import!(file, user)
      users = []
      CSV.foreach(file.path, encoding: Encoding::SJIS, headers: true) do |row|
        user = user.company.users.new
        user.attributes = row.to_hash.slice(*csv_attributes)
        users << user
      end
      begin
        import!(users, validate: true, validate_uniqueness: true)
      rescue ActiveRecord::RecordInvalid => e
        logger.error '[LOG]CSVアップデートのバリデーションエラー'
        logger.error "[LOG]エラークラス：#{e.class}"
        logger.error "[LOG]エラーメッセージ：#{e.message}"
        users = []
        retry
      end
    end

    def generate_csv_by(user)
      CSV.generate(encoding: Encoding::SJIS, headers: true) do |csv|
        csv << csv_attributes
        same_company_with(user).find_each do |each_user|
          csv << csv_attributes.map do |attr|
            each_user.send(attr)
          end
        end
      end
    end
  end
end
