# frozen_string_literal: true

class CreateSqlConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :sql_conditions, comment: '検索条件テーブル' do |t|
      t.string :code,     null: false,                    comment: '検索対象フックコード'
      t.text :condition,                                  comment: '検索条件'
      t.references :user, null: false, foreign_key: true, comment: 'アカウントID'

      t.timestamps
    end
  end
end
