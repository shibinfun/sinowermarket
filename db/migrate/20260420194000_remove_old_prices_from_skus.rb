class RemoveOldPricesFromSkus < ActiveRecord::Migration[8.0]
  def change
    remove_column :skus, :original_price, :decimal
    remove_column :skus, :current_price, :decimal
  end
end
