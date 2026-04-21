class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone
      t.string :province
      t.string :city
      t.string :district
      t.string :detail_address
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
