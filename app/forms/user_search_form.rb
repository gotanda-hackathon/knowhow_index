# frozen_string_literal: true

class UserSearchForm
  include ActiveModel::Model

  attr_accessor :user_ids
  attr_accessor :email
  attr_accessor :grader

  def search(current_user)
    records = User.same_company_with(current_user)
    records = scoped_by_user(records)
    records = scoped_by_email(records)
    records = scoped_by_grader(records)
    records.order(:id)
  end

  private

  def scoped_by_user(records)
    return records if user_ids.nil? || user_ids.join.empty?

    records.where(id: user_ids)
  end

  def scoped_by_email(records)
    return records if email.blank?

    records.where('email LIKE (?)', "%#{email}%")
  end

  def scoped_by_grader(records)
    return records if grader.blank?

    records.where(grader: grader)
  end
end
