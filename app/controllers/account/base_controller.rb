module Account
  class BaseController < ApplicationController
    layout "account"

    before_action :authenticate_user!
  end
end
