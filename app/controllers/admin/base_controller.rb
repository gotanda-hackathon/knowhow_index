# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :not_accessible_except_to_administrator

  private

  def not_accessible_except_to_administrator
    redirect_to root_url, flash: { red: t('views.flash.not_have_authority') } unless current_user.administrator?
  end
end
