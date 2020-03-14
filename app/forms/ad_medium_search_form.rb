# frozen_string_literal: true

class AdMediumSearchForm
  include ActiveModel::Model

  attr_accessor :name

  def search(current_user)
    records = AdMedium.same_company_with(current_user)
    records = scoped_by_name(records)
    records.order(:id)
  end

  private

  def scoped_by_name(records)
    return records if name.blank?

    records.where('name LIKE (?)', "%#{name}%")
  end
end
