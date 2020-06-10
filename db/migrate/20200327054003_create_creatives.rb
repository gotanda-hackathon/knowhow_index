# frozen_string_literal: true

class CreateCreatives < ActiveRecord::Migration[6.0]
  def change
    create_table :creatives, comment: 'クリエイティブテーブル' do |t|
      t.string  :name, comment: '企業名'
      t.integer :company_id, null: false, comment: '企業ID'
      t.timestamps
    end
  end
end
