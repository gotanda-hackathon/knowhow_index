# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]
  before_action :not_accessible_except_to_grader, only: %i[new edit update destroy]
  before_action :require_setting_csv_file, only: %i[csv_import]
  before_action :set_date_for_csv, only: %i[index]

  def index
    condition = current_user.get_search_condition(code: 'user', params: search_params.to_unsafe_h)
    @search_form = UserSearchForm.new(condition)
    @users = @search_form.search(current_user).paginated(params[:page]).decorate

    respond_to do |format|
      format.html
      format.csv { send_data User.generate_csv_by(current_user), filename: "users-#{@date}.csv" }
    end
  end

  def csv_import
    before_count = User.count
    User.csv_import!(params[:file], current_user)
    imported_count = User.count - before_count
    if imported_count.zero?
      redirect_to company_users_url(current_user.company), flash: { red: t('views.flash.fail_csv_data') }
    else
      redirect_to company_users_url(current_user.company), flash: { green: t('views.flash.create_csv_data', count: imported_count) }
    end
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

  def require_setting_csv_file
    redirect_to company_users_url(current_user.company), flash: { red: t('views.flash.non_csv_file') } unless params[:file].present? && File.extname(params[:file].original_filename) == '.csv'
  end

  def set_date_for_csv
    @date = Time.zone.now.strftime('%Y%m%d-%H%M%S')
  end
end
