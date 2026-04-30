class Admin::VisitorsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @visitors = Visitor.order(created_at: :desc).page(params[:page]).per(20)
  end

  def destroy_all
    Visitor.delete_all
    redirect_to admin_visitors_path, notice: t('notices.visitors.cleared_all')
  end

  def clean_old
    Visitor.where('created_at < ?', 7.days.ago).delete_all
    redirect_to admin_visitors_path, notice: t('notices.visitors.cleared_old')
  end
end
