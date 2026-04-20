module Admin
  class SkusController < BaseController
    before_action :set_sku, only: %i[ show edit update destroy delete_image ]

    def index
      @skus = Sku.all.includes(:category, images_attachments: :blob).order(created_at: :desc)
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
      @skus = @skus.page(params[:page]).per(20)
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
      # 从参数中提取图片，但不直接传递给 update，以防覆盖
      images = sku_params[:images]
      image_positions = params.dig(:sku, :image_positions)
      update_params = sku_params.except(:images)

      if @sku.update(update_params)
        @sku.images.attach(images) if images.present?
        
        # 处理手动设置的图片排序
        if image_positions.present?
          image_positions.each do |id, position|
            @sku.images.find_by(id: id)&.update(position: position)
          end
        end

        redirect_to admin_skus_path, notice: "Sku was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sku.destroy
      redirect_to admin_skus_path, notice: "Sku was successfully destroyed.", status: :see_other
    end

    def delete_image
      image = @sku.images.find(params[:image_id])
      image.purge
      redirect_to edit_admin_sku_path(@sku), notice: "Image was successfully deleted."
    end

    private
      def set_sku
        @sku = Sku.find(params[:id])
      end

      def sku_params
        params.require(:sku).permit(:name, :original_price, :current_price, :description, :technical_data, :category_id, :specsheet, images: []).tap do |p|
          if p[:images].present?
            p[:images] = p[:images].reject(&:blank?)
          end
          p.delete(:specsheet) if p[:specsheet].blank?
        end
      end
  end
end
