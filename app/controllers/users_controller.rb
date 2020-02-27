# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :not_accessible_different_company_user_data, only: %i[edit update destroy]

  def index
    @users = User.same_as_current_user_company(current_user).order(:id).page(params[:page]).per(Settings.pagination.default).decorate
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to company_users_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to edit_company_user_url(current_user.company, @user), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to company_users_url(current_user.company), flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :grader, :company_id)
  end

  def not_accessible_different_company_user_data
    redirect_to root_url, flash: { red: t('views.flash.non_administrator') } if current_user.company != @user.company
  end
end
