class AddLocalesToSkus < ActiveRecord::Migration[8.0]
  def change
    add_column :skus, :name_fr, :string
    add_column :skus, :name_es, :string
  end
end
