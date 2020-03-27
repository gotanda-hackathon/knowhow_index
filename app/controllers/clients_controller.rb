# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[edit update destroy]
  before_action :not_accessible_different_company_data, only: %i[edit update destroy]

  def index
    condition = current_user.get_search_condition(code: 'client', params: search_params.to_unsafe_h)
    @search_form = ClientSearchForm.new(condition)
    @clients = @search_form.search(current_user).paginated(params[:page]).decorate
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to company_clients_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to company_clients_url(current_user.company, @client), flash: { green: t('views.flash.update_success') }
    else
      flash.now[:red] = t('views.flash.update_danger')
      render :edit
    end
  end

  def destroy
    @client.destroy!
    redirect_to company_clients_url(current_user.company), flash: { green: t('views.flash.destroy_success') }
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :company_id)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end

  def not_accessible_different_company_data
    redirect_to root_url, flash: { red: t('views.flash.not_accessible_different_company_data') } if current_user.company != @client.company
  end
end
