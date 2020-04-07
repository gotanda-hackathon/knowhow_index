class CreativesController < ApplicationController

  before_action :set_creative, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]
  before_action :not_accessible_except_to_grader, only: %i[new edit update destroy]
  before_action :require_setting_csv_file, only: %i[csv_import]
  before_action :require_setting_csv_file, only: %i[csv_import]
  before_action :set_date_for_csv, only: %i[index]


  def index
    condition = current_user.get_search_condition(code: 'creative', params: search_params.to_unsafe_h)
    @search_form = CreativeSearchForm.new(condition)
    @creatives  = @search_form.search(current_user).paginated(params[:page]).decorate

    respond_to do |format|
      format.html
      format.csv { send_data Creative.generate_csv_by(current_user), filename: "creative-#{@date}.csv" }
    end
  end

  def new
    @creative = Creative.new
  end

  def edit; end

  def create
    @creative = Creative.new(creative_params)

    if @creative.save
      redirect_to company_creatives_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def update
    if @create.update(creative_params)
      redirect_to edit_company_user_url(current_user.company, @creative), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @creative.destroy!
    redirect_to company_creatives_url(current_user.company), flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_creative
    @creative = Creative.find(params[:id])
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end

  def creative_params
    params.require(:creative).permit(:name, :company_id)
  end

  def require_setting_csv_file
    redirect_to company_creative_url(current_user.company), flash: { red: t('views.flash.non_csv_file') } unless params[:file].present? && File.extname(params[:file].original_filename) == '.csv'
  end

  def set_date_for_csv
    @date = Time.zone.now.strftime('%Y%m%d-%H%M%S')
  end

  def not_accessible_different_company_data
    redirect_to root_url, flash: { red: t('views.flash.not_accessible_different_company_data') } if current_user.company != @ad_medium.company
  end

  def not_accessible_except_to_grader
    redirect_to root_url, flash: { red: t('views.flash.not_have_authority') } unless current_user.grader?
  end

  
end