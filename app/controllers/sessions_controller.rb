# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_logged_in

  def new
    redirect_to root_url, flash: { red: t('views.flash.logged_in_user') } if logged_in?
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      redirect_to root_url, flash: { green: t('views.flash.login_success') }
    else
      flash.now[:red] = t('views.flash.login_danger')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, flash: { green: t('views.flash.logout_success') }
  end

  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user&.authenticate(password)
      session[:user_id] = @user.id
      true
    else
      false
    end
  end
end
