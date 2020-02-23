# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def error_messages_for(attribute)
    ApplicationController.helpers.safe_join(errors.full_messages_for(attribute), ApplicationController.helpers.tag(:br))
  end
end
