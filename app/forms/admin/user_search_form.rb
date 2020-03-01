# frozen_string_literal: true

class Admin::UserSearchForm
  include ActiveModel::Model

  attr_accessor :user_ids
  attr_accessor :company_ids
  attr_accessor :email
  attr_accessor :grader
  attr_accessor :administrator

  def search
    records = User.includes(:company).all
    records = scoped_by_user(records)
    records = scoped_by_company(records)
    records = scoped_by_email(records)
    records = scoped_by_grader(records)
    records = scoped_by_administrator(records)
    records.order(:id)
  end

  private

  def scoped_by_user(records)
    return records if user_ids.nil? || user_ids.join.empty?

    records.where(id: user_ids)
  end

  def scoped_by_company(records)
    return records if company_ids.nil? || company_ids.join.empty?

    records.where(company_id: company_ids)
  end

  def scoped_by_email(records)
    return records if email.blank?

    records.where('email LIKE (?)', "%#{email}%")
  end

  def scoped_by_grader(records)
    return records if grader.blank?

    records.where(grader: grader)
  end

  def scoped_by_administrator(records)
    return records if administrator.blank?

    records.where(administrator: administrator)
  end
end
