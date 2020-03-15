# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginated, lambda { |params|
      page(params).per(Settings.pagination.default)
    }
  end
end
