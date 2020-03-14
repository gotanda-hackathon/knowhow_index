# frozen_string_literal: true

class Admin::CompaniesController < Admin::BaseController
  before_action :set_company, only: %i[edit update destroy]

  def index
    condition = current_user.get_search_condition(code: 'admin/company', params: search_params.to_unsafe_h)
    @search_form = Admin::CompanySearchForm.new(condition)
    @companies = @search_form.search.page(params[:page]).per(Settings.pagination.default).decorate
  end

  def new
    @company = Company.new
  end

  def edit; end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to admin_companies_url, flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to edit_admin_company_url(@company), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @company.destroy!
    redirect_to admin_companies_url, flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end
end
