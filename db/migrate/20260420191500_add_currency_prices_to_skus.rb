class AddCurrencyPricesToSkus < ActiveRecord::Migration[8.0]
  def change
    add_column :skus, :original_price_usd, :decimal, precision: 10, scale: 2
    add_column :skus, :current_price_usd, :decimal, precision: 10, scale: 2
    add_column :skus, :original_price_cad, :decimal, precision: 10, scale: 2
    add_column :skus, :current_price_cad, :decimal, precision: 10, scale: 2
    
    # 将旧的数据迁移到 USD (假设原来的数据是 USD)
    reversible do |dir|
      dir.up do
        Sku.reset_column_information
        Sku.all.each do |sku|
          sku.update_columns(
            original_price_usd: sku.original_price,
            current_price_usd: sku.current_price
          )
        end
      end
    end
  end
end
