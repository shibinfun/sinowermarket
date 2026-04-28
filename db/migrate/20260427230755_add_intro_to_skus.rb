class AddIntroToSkus < ActiveRecord::Migration[8.0]
  def change
    add_column :skus, :intro, :text
    add_column :skus, :intro_fr, :text
    add_column :skus, :intro_es, :text
  end
end
