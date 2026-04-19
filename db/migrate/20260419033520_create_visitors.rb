class CreateVisitors < ActiveRecord::Migration[8.0]
  def change
    create_table :visitors do |t|
      t.string :ip
      t.string :location
      t.string :path
      t.string :user_agent

      t.timestamps
    end
  end
end
