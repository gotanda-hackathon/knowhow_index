# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy]

  def index
    condition = current_user.get_search_condition(code: 'admin/user', params: user_search_params.to_unsafe_h)
    @search_form = Admin::UserSearchForm.new(condition)
    @users = @search_form.search.page(params[:page]).per(Settings.pagination.default).decorate
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

  def user_search_params
    params.fetch(:search_form, {}).permit(:email, :grader, :administrator, company_ids: [], user_ids: [])
  end
end
