module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :require_admin

    private

    def require_admin
      unless current_user.admin?
        redirect_to root_path, alert: t('alerts.admin.access_denied')
      end
    end
  end
end
