class AddCurrencyToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :currency, :string, default: "USD"
  end
end
