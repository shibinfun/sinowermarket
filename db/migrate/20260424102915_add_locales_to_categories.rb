class AddLocalesToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :name_fr, :string
    add_column :categories, :name_es, :string
  end
end
