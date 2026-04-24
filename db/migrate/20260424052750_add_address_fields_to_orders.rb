class AddAddressFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :province, :string unless column_exists?(:orders, :province)
    add_column :orders, :city, :string unless column_exists?(:orders, :city)
    add_column :orders, :district, :string unless column_exists?(:orders, :district)
    add_column :orders, :detail_address, :string unless column_exists?(:orders, :detail_address)
  end
end
