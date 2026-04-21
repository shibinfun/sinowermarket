module Account
  class AddressesController < BaseController
    before_action :set_address, only: [:edit, :update, :destroy, :set_default]

    def index
      @addresses = current_user.addresses.ordered
    end

    def new
      @address = current_user.addresses.build
    end

    def edit
    end

    def create
      @address = current_user.addresses.build(address_params)

      if @address.save
        redirect_to account_addresses_path, notice: "Address was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @address.update(address_params)
        redirect_to account_addresses_path, notice: "Address was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @address.destroy
      redirect_to account_addresses_path, notice: "Address was successfully deleted.", status: :see_other
    end

    def set_default
      @address.update(is_default: true)
      redirect_to account_addresses_path, notice: "Default address updated."
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
