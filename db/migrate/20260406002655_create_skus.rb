class CreateSkus < ActiveRecord::Migration[8.0]
  def change
    create_table :skus do |t|
      t.string :name
      t.decimal :original_price, precision: 10, scale: 2
      t.decimal :current_price, precision: 10, scale: 2
      t.text :description
      t.text :technical_data
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
