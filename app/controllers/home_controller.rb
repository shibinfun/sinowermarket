class HomeController < ApplicationController
  def index
    @categories = Category.roots.includes(image_attachment: :blob, children: { image_attachment: :blob }).ordered
  end

  def help_center
  end

  def contact
  end

  def change_locale
    locale = params[:locale].to_sym
    if I18n.available_locales.include?(locale)
      session[:locale] = locale
    end
    redirect_back fallback_location: root_path
  end

  def change_currency
    currency = params[:currency]
    if ["USD", "CAD"].include?(currency)
      session[:currency] = currency
    end
    redirect_back fallback_location: root_path
  end
end
