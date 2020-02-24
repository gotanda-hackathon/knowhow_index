# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = UserDecorator.decorate_collection(User.all).includes(:company)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_url, flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to edit_admin_user_url(@user), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_url, flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :grader, :administrator, :company_id)
  end
end
