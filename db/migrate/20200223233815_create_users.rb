# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, comment: 'ユーザーテーブル' do |t|
      t.string :name,            null: false,                    comment: '氏名'
      t.string :email,           null: false,                    comment: 'メールアドレス'
      t.string :password_digest, null: false,                    comment: 'パスワード'
      t.boolean :grader,         null: false, default: false,    comment: '採点者フラグ'
      t.boolean :administrator,  null: false, default: false,    comment: '管理者フラグ'
      t.references :company,     null: false, foreign_key: true, comment: '企業ID'

      t.timestamps
    end
  end
end
