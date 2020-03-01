# frozen_string_literal: true

# == Schema Information
#
# Table name: sql_conditions # 検索条件テーブル
#
#  id                         :bigint           not null, primary key
#  code(検索対象フックコード) :string           not null
#  condition(検索条件)        :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  user_id(アカウントID)      :bigint           not null
#
# Indexes
#
#  index_sql_conditions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class SqlCondition < ApplicationRecord
  belongs_to :user
end
