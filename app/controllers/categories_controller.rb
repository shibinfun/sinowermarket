class CategoriesController < ApplicationController
  def show
    redirect_to skus_path(category_id: params[:id])
  end
end
