# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_logged_in

  helper_method :current_user
  helper_method :logged_in?

  private

  def require_logged_in
    redirect_to login_url, flash: { red: t('views.flash.non_logged_in_user') } unless logged_in?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
