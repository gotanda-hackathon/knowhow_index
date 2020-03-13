# frozen_string_literal: true

module CompanyMatchable
  extend ActiveSupport::Concern

  included do
    scope :same_as_current_user_company, lambda { |user|
      all.where(company: user.company)
    }
  end
end
