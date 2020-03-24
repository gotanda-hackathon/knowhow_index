# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories, comment: 'カテゴリマスターテーブル' do |t|
      t.string :name,        null: false,                    comment: 'カテゴリ名'
      t.references :company, null: false, foreign_key: true, comment: '企業ID'

      t.timestamps
    end
  end
end
