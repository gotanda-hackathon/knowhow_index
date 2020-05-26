# frozen_string_literal: true

class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators, comment: '改善指標マスターテーブル' do |t|
      t.string :name,        null: false,                    comment: '改善指標名'
      t.references :company, null: false, foreign_key: true, comment: '企業ID'

      t.timestamps
    end
  end
end
