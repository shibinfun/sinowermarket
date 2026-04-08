class CartItemsController < ApplicationController
  def create
    @sku = Sku.find(params[:sku_id])
    @cart_item = current_cart.cart_items.find_or_initialize_by(sku_id: @sku.id)
    @cart_item.quantity = (@cart_item.quantity || 0) + (params[:quantity] || 1).to_i

    if @cart_item.save
      redirect_back fallback_location: skus_path, notice: "Added #{@sku.name} to cart."
    else
      redirect_back fallback_location: skus_path, alert: "Could not add item to cart."
    end
  end

  def update
    @cart_item = current_cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: "Cart updated."
    else
      redirect_to cart_path, alert: "Could not update cart."
    end
  end

  def destroy
    @cart_item = current_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
