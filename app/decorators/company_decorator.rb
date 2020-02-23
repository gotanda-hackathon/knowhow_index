# frozen_string_literal: true

class CompanyDecorator < Draper::Decorator
  delegate_all

  def show_created_at
    I18n.l(created_at, format: :long)
  end
end
