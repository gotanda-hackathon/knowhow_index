# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]
  before_action :not_accessible_except_to_grader, only: %i[new edit update destroy]

  def index
    condition = current_user.get_search_condition(code: 'user', params: search_params.to_unsafe_h)
    @search_form = UserSearchForm.new(condition)
    @users = @search_form.search(current_user).page(params[:page]).per(Settings.pagination.default).decorate
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

  def search_params
    params.fetch(:search_form, {}).permit(:email, :grader, user_ids: [])
  end

  def not_accessible_different_company_data
    redirect_to root_url, flash: { red: t('views.flash.not_accessible_different_company_data') } if current_user.company != @user.company
  end

  def not_accessible_except_to_grader
    redirect_to root_url, flash: { red: t('views.flash.not_have_authority') } unless current_user.grader?
  end
end
