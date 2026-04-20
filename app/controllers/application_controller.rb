class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_locale
  before_action :set_currency
  before_action :set_navbar_categories
  before_action :track_visitor
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

  def track_visitor
    # 忽略后台请求和资源文件请求
    return if request.path.start_with?('/admin', '/assets', '/rails')
    
    # 记录访问
    Visitor.create(
      ip: request.remote_ip,
      path: request.fullpath,
      user_agent: request.user_agent,
      location: "Local/Unknown" # 暂时填入未知，后续可以考虑集成地理位置API
    )

    # 随机触发清理旧数据 (1% 的概率)
    if rand < 0.01
      Visitor.where('created_at < ?', 7.days.ago).delete_all
    end
  end

  def set_navbar_categories
    @categories = Category.roots.includes(:children).ordered
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def set_currency
    @currency = params[:currency] || session[:currency] || "USD"
    session[:currency] = @currency
  end
end
