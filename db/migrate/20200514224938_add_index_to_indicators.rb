# frozen_string_literal: true

class AddIndexToIndicators < ActiveRecord::Migration[6.0]
  def change
    add_index :categories, %i[name company_id], unique: true
  end
end
