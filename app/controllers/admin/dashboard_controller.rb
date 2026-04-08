module Admin
  class DashboardController < BaseController
    def index
      @total_sales = 128500
      @total_orders = 1243
      @total_customers = 842
      @total_products = 156
      @sales_growth = 12.5
      @orders_growth = 8.2
      @customers_growth = 15.3
      @products_growth = 5.0
    end
  end
end
