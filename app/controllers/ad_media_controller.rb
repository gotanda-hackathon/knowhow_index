# frozen_string_literal: true

class AdMediaController < ApplicationController
  def index
    condition = current_user.get_search_condition(code: 'ad_medium', params: search_params.to_unsafe_h)
    @search_form = AdMediumSearchForm.new(condition)
    @ad_media = @search_form.search(current_user).page(params[:page]).per(Settings.pagination.default).decorate
  end

  def new; end

  def edit; end

  private

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end
end
