class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_navbar_categories
  helper_method :current_cart

  def current_cart
    if user_signed_in?
      @current_cart ||= current_user.cart || current_user.create_cart
    else
      if session[:cart_id]
        @current_cart ||= Cart.find_by(id: session[:cart_id])
      end

      if @current_cart.nil?
        @current_cart = Cart.create
        session[:cart_id] = @current_cart.id
      end
    end
    @current_cart
  end

  private

  def set_navbar_categories
    @categories = Category.roots.includes(:children).ordered
  end
end
