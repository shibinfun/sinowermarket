class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: [:new, :create]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = current_user.orders.new
    @order.build_from_cart(current_cart, @currency)
    
    # Pre-fill with default address if available
    if default_address = current_user.addresses.find_by(is_default: true)
      @order.name = default_address.name
      @order.phone = default_address.phone
      @order.province = default_address.province
      @order.city = default_address.city
      @order.district = default_address.district
      @order.detail_address = default_address.detail_address
      @order.address = default_address.full_address
    end

    @addresses = current_user.addresses.ordered
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.build_from_cart(current_cart, @currency)

    if @order.save
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to @order, notice: "Order was successfully created."
    else
      @addresses = current_user.addresses.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def pay
    @order = current_user.orders.find(params[:id])
    if @order.pending?
      if @order.update(status: "paid")
        redirect_to @order, notice: "Order paid successfully!"
      else
        redirect_to @order, alert: "Payment failed."
      end
    else
      redirect_to @order, alert: "This order cannot be paid."
    end
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    if @order.can_cancel?
      if @order.cancel!
        redirect_to @order, notice: "Order has been cancelled."
      else
        redirect_to @order, alert: "Failed to cancel the order."
      end
    else
      redirect_to @order, alert: "This order cannot be cancelled."
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone, :province, :city, :district, :detail_address)
  end

  def ensure_cart_not_empty
    if current_cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end
end
