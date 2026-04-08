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
    @order.build_from_cart(current_cart)
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.build_from_cart(current_cart)

    if @order.save
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to @order, notice: "Order was successfully created."
    else
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
    params.require(:order).permit(:name, :address, :phone)
  end

  def ensure_cart_not_empty
    if current_cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end
end
