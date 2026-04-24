module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[ show edit update destroy ]

    def index
      @categories = Category.roots.includes(:children).ordered
    end

    def show
    end

    def new
      @category = Category.new(parent_id: params[:parent_id])
    end

    def edit
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: "Category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Category was successfully destroyed.", status: :see_other
    end

    private
      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :name_fr, :name_es, :parent_id, :position, :image).tap do |p|
          p.delete(:image) if p[:image].blank?
        end
      end
  end
end
