# frozen_string_literal: true

class Admin::CompanySearchForm
  include ActiveModel::Model

  attr_accessor :name

  def search
    records = Company.all
    records = scoped_by_name(records)
    records.order(:id)
  end

  private

  def scoped_by_name(records)
    return records if name.blank?

    records.where('name LIKE (?)', "%#{name}%")
  end
end
