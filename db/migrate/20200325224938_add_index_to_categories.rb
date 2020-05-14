# frozen_string_literal: true

class AddIndexToCategories < ActiveRecord::Migration[6.0]
  def change
    add_index :categories, %i[name company_id], unique: true
  end
end
