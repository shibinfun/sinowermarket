class AddKindToSkus < ActiveRecord::Migration[8.0]
  def change
    add_column :skus, :kind, :integer
  end
end
