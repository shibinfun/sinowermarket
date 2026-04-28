class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :set_currency
  before_action :set_navbar_categories
  before_action :track_visitor
  before_action :merge_cart
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

  def merge_cart
    return unless user_signed_in? && session[:cart_id]
    
    guest_cart = Cart.find_by(id: session[:cart_id])
    if guest_cart && guest_cart.user.nil?
      user_cart = current_user.cart || current_user.create_cart
      
      guest_cart.cart_items.each do |guest_item|
        user_item = user_cart.cart_items.find_or_initialize_by(sku_id: guest_item.sku_id)
        if user_item.persisted?
          user_item.quantity += guest_item.quantity
        else
          user_item.quantity = guest_item.quantity
        end
        user_item.save
      end
      
      guest_cart.destroy
      session.delete(:cart_id)
    end
  end

  private

  def track_visitor
    # 忽略后台请求和资源文件请求
    return if request.path.start_with?('/admin', '/assets', '/rails')
    
    # 记录访问
    Visitor.create(
      ip: anonymize_ip(request.remote_ip),
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
    I18n.locale = params[:locale] || session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def set_currency
    @currency = params[:currency] || session[:currency] || "USD"
    session[:currency] = @currency
  end

  def anonymize_ip(ip)
    return ip if ip.blank?
    if ip.include?('.') # IPv4
      ip.split('.')[0..2].join('.') + '.0'
    elsif ip.include?(':') # IPv6
      ip.split(':')[0..2].join(':') + '::0'
    else
      ip
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:terms_of_service])
  end
end
