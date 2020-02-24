# == Schema Information
#
# Table name: users # ユーザーテーブル
#
#  id                          :bigint           not null, primary key
#  admin(管理者フラグ)         :boolean          default("false"), not null
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
  belongs_to :company
end
