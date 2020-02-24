# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :not_accessible_by_normal_user

  private

  def not_accessible_by_normal_user
    redirect_to root_url, flash: { red: t('views.flash.non_administrator') } unless current_user.administrator?
  end
end
