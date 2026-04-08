class HomeController < ApplicationController
  def index
    @categories = Category.roots.includes(:children).ordered
  end

  def help_center
  end
end
