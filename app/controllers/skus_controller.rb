class SkusController < ApplicationController
  def index
    @skus = Sku.includes(:category, images_attachments: :blob).all
    if params[:query].present?
      @skus = @skus.where("name LIKE ?", "%#{params[:query]}%")
    end

    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      if @category.parent_id.nil?
        @skus = @skus.where(category_id: @category.children.pluck(:id))
      else
        @skus = @skus.where(category_id: params[:category_id])
      end
    end

    apply_sorting
    @skus = @skus.page(params[:page]).per(12)
  end

  def show
    @sku = Sku.with_attached_images.with_attached_specsheet.find(params[:id])
    @category = @sku.category
    @parent_category = @category.parent
  end

  private

  def apply_sorting
    case params[:sort]
    when "price_asc"
      @skus = @skus.order(current_price: :asc)
    when "price_desc"
      @skus = @skus.order(current_price: :desc)
    else
      @skus = @skus.order(created_at: :desc)
    end
  end
end
