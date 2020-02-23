class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies, comment: '利用企業テーブル' do |t|
      t.string :name, comment: '企業名'

      t.timestamps
    end
  end
end
