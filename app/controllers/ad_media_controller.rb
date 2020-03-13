# frozen_string_literal: true

class AdMediaController < ApplicationController
  before_action :not_grader, only: %i[new edit update destroy]

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

  private

  def ad_medium_params
    params.require(:ad_medium).permit(:name, :company_id)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end

  def not_grader
    redirect_to root_url, flash: { red: t('views.flash.non_administrator') } unless current_user.grader?
  end
end
