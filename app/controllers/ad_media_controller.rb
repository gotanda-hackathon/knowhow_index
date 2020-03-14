# frozen_string_literal: true

class AdMediaController < ApplicationController
  before_action :set_ad_medium, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]
  before_action :not_accessible_except_to_grader, only: %i[new edit update destroy]

  def index
    condition = current_user.get_search_condition(code: 'ad_medium', params: search_params.to_unsafe_h)
    @search_form = AdMediumSearchForm.new(condition)
    @ad_media = @search_form.search(current_user).page(params[:page]).per(Settings.pagination.default).decorate
  end

  def new
    @ad_medium = AdMedium.new
  end

  def create
    @ad_medium = AdMedium.new(ad_medium_params)

    if @ad_medium.save
      redirect_to company_ad_media_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def edit; end

  def update
    if @ad_medium.update(ad_medium_params)
      redirect_to edit_company_ad_medium_url(current_user.company, @ad_medium), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @ad_medium.destroy!
    redirect_to company_ad_media_url(current_user.company), flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_ad_medium
    @ad_medium = AdMedium.find(params[:id])
  end

  def ad_medium_params
    params.require(:ad_medium).permit(:name, :company_id)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end

  def not_accessible_different_company_data
    redirect_to root_url, flash: { red: t('views.flash.not_accessible_different_company_data') } if current_user.company != @ad_medium.company
  end

  def not_accessible_except_to_grader
    redirect_to root_url, flash: { red: t('views.flash.not_have_authority') } unless current_user.grader?
  end
end
