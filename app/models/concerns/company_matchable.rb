# frozen_string_literal: true

module CompanyMatchable
  extend ActiveSupport::Concern

  included do
    scope :same_company_with, lambda { |user|
      all.where(company: user.company)
    }
  end
end
