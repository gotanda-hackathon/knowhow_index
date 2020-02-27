# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_logged_in

  helper_method :current_user
  helper_method :logged_in?

  rescue_from Exception, with: :error500
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404

  private

  def require_logged_in
    redirect_to login_url, flash: { red: t('views.flash.non_logged_in_user') } unless logged_in?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def error500(error)
    user_name = current_user&.name

    logger.error "[エラーユーザー名]#{user_name}"
    logger.error "[LOG]エラークラス：#{error.class}"
    logger.error "[LOG]エラーメッセージ：#{error.message}"
    logger.error '[LOG]バックトレース -----'
    logger.error error.backtrace
    logger.error '-----'
    render 'error500', status: :internal_server_error, formats: [:html]
  end

  def error404
    render 'error404', status: :not_found, formats: [:html]
  end

  def logged_in?
    !current_user.nil?
  end
end
