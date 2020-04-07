class CreativesController < ApplicationController
  def index
    condition = current_user.get_search_condition(code: 'creative', params: search_params.to_unsafe_h)
    @search_form = CreativeSearchForm.new(condition)
    @creatives  = @search_form.search(current_user).paginated(params[:page]).decorate
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end
end