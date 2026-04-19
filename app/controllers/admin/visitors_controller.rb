class Admin::VisitorsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @visitors = Visitor.order(created_at: :desc).page(params[:page]).per(20)
  end

  def destroy_all
    Visitor.delete_all
    redirect_to admin_visitors_path, notice: "All visitor data has been cleared."
  end

  def clean_old
    Visitor.where('created_at < ?', 7.days.ago).delete_all
    redirect_to admin_visitors_path, notice: "Data older than 7 days has been cleared."
  end
end
