# frozen_string_literal: true

class AddIndexToModels < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email, unique: true
    add_index :companies, :name, unique: true
    add_index :ad_media, %i[name company_id], unique: true
  end
end
