class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.decimal :total_price, precision: 10, scale: 2
      t.string :status, default: "pending"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
