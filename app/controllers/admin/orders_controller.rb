module Admin
  class OrdersController < BaseController
    before_action :set_order, only: [:show, :ship, :complete, :cancel]

    def index
      @orders = Order.all.order(created_at: :desc)
    end

    def show
    end

    def ship
      if @order.can_ship?
        @order.ship!
        redirect_to admin_order_path(@order), notice: t('notices.orders.shipped')
      else
        redirect_to admin_order_path(@order), alert: t('alerts.orders.cannot_ship')
      end
    end

    def complete
      if @order.can_complete?
        @order.complete!
        redirect_to admin_order_path(@order), notice: t('notices.orders.completed')
      else
        redirect_to admin_order_path(@order), alert: t('alerts.orders.cannot_complete')
      end
    end

    def cancel
      # Admin can cancel if not already cancelled or delivered
      if !@order.cancelled? && !@order.delivered?
        @order.update(status: "cancelled")
        redirect_to admin_order_path(@order), notice: t('notices.orders.cancelled')
      else
        redirect_to admin_order_path(@order), alert: t('alerts.orders.cannot_cancel')
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
  end
end
