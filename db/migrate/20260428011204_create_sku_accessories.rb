class CreateSkuAccessories < ActiveRecord::Migration[8.0]
  def change
    create_table :sku_accessories do |t|
      t.references :sku, null: false, foreign_key: true
      t.references :accessory, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
