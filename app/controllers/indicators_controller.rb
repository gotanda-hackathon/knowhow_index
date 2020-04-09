# frozen_string_literal: true

class IndicatorsController < ApplicationController
  before_action :set_indicator, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]
  before_action :not_accessible_except_to_grader, only: %i[new edit update destroy]
  before_action :require_setting_csv_file, only: %i[csv_import]
  before_action :set_date_for_csv, only: %i[index]

  def index
    condition = current_user.get_search_condition(code: 'indicator', params: search_params.to_unsafe_h)
    @search_form = IndicatorSearchForm.new(condition)
    @indicators = @search_form.search(current_user).paginated(params[:page]).decorate

    respond_to do |format|
      format.html
      format.csv { send_data Indicator.generate_csv_by(current_user), filename: "indicators-#{@date}.csv" }
    end
  end

  def csv_import
    before_count = Indicator.count
    Indicator.csv_import!(params[:file], current_user)
    imported_count = Indicator.count - before_count
    if imported_count.zero?
      redirect_to company_indicators_url(current_user.company), flash: { red: t('views.flash.fail_csv_data') }
    else
      redirect_to company_indicators_url(current_user.company), flash: { green: t('views.flash.create_csv_data', count: imported_count) }
    end
  end

  def new
    @indicator = Indicator.new
  end

  def create
    @indicator = Indicator.new(indicator_params)

    if @indicator.save
      redirect_to company_indicators_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def edit; end

  def update
    if @indicator.update(indicator_params)
      redirect_to edit_company_indicator_url(current_user.company, @indicator), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @indicator.destroy!
    redirect_to company_indicators_url(current_user.company), flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_indicator
    @indicator = Indicator.find(params[:id])
  end

  def indicator_params
    params.require(:indicator).permit(:name, :company_id)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end

  def not_accessible_different_company_data
    redirect_to root_url, flash: { red: t('views.flash.not_accessible_different_company_data') } if current_user.company != @indicator.company
  end

  def not_accessible_except_to_grader
    redirect_to root_url, flash: { red: t('views.flash.not_have_authority') } unless current_user.grader?
  end

  def require_setting_csv_file
    redirect_to company_indicators_url(current_user.company), flash: { red: t('views.flash.non_csv_file') } unless params[:file].present? && File.extname(params[:file].original_filename) == '.csv'
  end

  def set_date_for_csv
    @date = Time.zone.now.strftime('%Y%m%d-%H%M%S')
  end
end
