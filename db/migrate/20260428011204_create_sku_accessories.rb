class CreateSkuAccessories < ActiveRecord::Migration[8.0]
  def change
    create_table :sku_accessories do |t|
      t.references :sku, null: false, foreign_key: true
      t.references :accessory, null: false, foreign_key: { to_table: :skus }
      t.integer :position, default: 0

      t.timestamps
    end
    add_index :sku_accessories, [:sku_id, :accessory_id], unique: true
  end
end
