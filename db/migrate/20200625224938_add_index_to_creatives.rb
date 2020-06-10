# frozen_string_literal: true

class AddIndexToCreatives < ActiveRecord::Migration[6.0]
  def change
    add_index :creatives, %i[name company_id], unique: true
  end
end
