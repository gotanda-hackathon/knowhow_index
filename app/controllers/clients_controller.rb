# frozen_string_literal: true

class ClientsController < ApplicationController
  def index
    condition = current_user.get_search_condition(code: 'client', params: search_params.to_unsafe_h)
    @search_form = ClientSearchForm.new(condition)
    @clients = @search_form.search(current_user).paginated(params[:page]).decorate
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
