# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients, comment: 'クライアントマスターテーブル' do |t|
      t.string :name,        null: false,                    comment: '媒体名'
      t.references :company, null: false, foreign_key: true, comment: '企業ID'

      t.timestamps
    end
    add_index :clients, %i[name company_id], unique: true
  end
end
