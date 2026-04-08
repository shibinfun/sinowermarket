module Admin
  class SkusController < BaseController
    before_action :set_sku, only: %i[ show edit update destroy ]

    def index
      @skus = Sku.all.includes(:category).order(created_at: :desc)
      if params[:category_id].present?
        category = Category.find(params[:category_id])
        if category.parent_id.nil?
          # If it's a root category, show all SKUs from its children
          @skus = @skus.where(category_id: category.children.pluck(:id))
        else
          # If it's a sub category, show SKUs in that category
          @skus = @skus.where(category_id: params[:category_id])
        end
      end
    end

    def show
    end

    def new
      @sku = Sku.new
    end

    def edit
    end

    def create
      @sku = Sku.new(sku_params)

      if @sku.save
        redirect_to admin_skus_path, notice: "Sku was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @sku.update(sku_params)
        redirect_to admin_skus_path, notice: "Sku was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sku.destroy
      redirect_to admin_skus_path, notice: "Sku was successfully destroyed.", status: :see_other
    end

    private
      def set_sku
        @sku = Sku.find(params[:id])
      end

      def sku_params
        params.require(:sku).permit(:name, :original_price, :current_price, :description, :technical_data, :category_id, :specsheet, images: [])
      end
  end
end
