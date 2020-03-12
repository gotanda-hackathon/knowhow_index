# frozen_string_literal: true

class CreateAdMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :ad_media, comment: '広告媒体マスターテーブル' do |t|
      t.string :name,        null: false,                    comment: '媒体名'
      t.references :company, null: false, foreign_key: true, comment: '企業ID'

      t.timestamps
    end
  end
end
