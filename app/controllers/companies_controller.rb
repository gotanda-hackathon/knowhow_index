# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[edit update destroy]

  def index
    @companies = CompanyDecorator.decorate_collection(Company.all)
  end

  def new
    @company = Company.new
  end

  def edit; end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to companies_url, flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to edit_company_url(@company), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @company.destroy!
    redirect_to companies_url, flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name)
  end
end
