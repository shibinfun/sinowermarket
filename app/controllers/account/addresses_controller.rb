module Account
  class AddressesController < BaseController
    before_action :set_address, only: [:edit, :update, :destroy, :set_default]

    def index
      @addresses = current_user.addresses.ordered
    end

    def new
      if current_user.addresses.count >= 3
        redirect_to account_addresses_path, alert: t('alerts.addresses.max_reached')
      else
        @address = current_user.addresses.build
      end
    end

    def edit
    end

    def create
      if current_user.addresses.count >= 3
        redirect_to account_addresses_path, alert: t('alerts.addresses.max_reached')
      else
        @address = current_user.addresses.build(address_params)

        if @address.save
          redirect_to account_addresses_path, notice: t('notices.addresses.created')
        else
          render :new, status: :unprocessable_entity
        end
      end
    end

    def update
      if @address.update(address_params)
        redirect_to account_addresses_path, notice: t('notices.addresses.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @address.destroy
      redirect_to account_addresses_path, notice: t('notices.addresses.destroyed'), status: :see_other
    end

    def set_default
      @address.update(is_default: true)
      redirect_to account_addresses_path, notice: t('notices.addresses.default_updated')
    end

    private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    def address_params
      params.require(:address).permit(:name, :phone, :province, :city, :district, :detail_address, :is_default)
    end
  end
end
