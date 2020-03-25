# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    condition = current_user.get_search_condition(code: 'category', params: search_params.to_unsafe_h)
    @search_form = CategorySearchForm.new(condition)
    @categories  = @search_form.search(current_user).paginated(params[:page]).decorate
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to company_categories_url(current_user.company), flash: { green: t('views.flash.create_success') }
    else
      flash.now[:red] = t('views.flash.create_danger')
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def category_params
    params.require(:category).permit(:name, :company_id)
  end

  def search_params
    params.fetch(:search_form, {}).permit(:name)
  end
end
