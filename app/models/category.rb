# frozen_string_literal: true

class Category < ApplicationRecord
  include CompanyMatchable

  belongs_to :company
end
