class HomeController < ApplicationController
  def index
    @categories = Category.roots.includes(image_attachment: :blob, children: { image_attachment: :blob }).ordered
  end

  def help_center
  end
end
