class AddSoldToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :sold, :boolean
    add_index :items, :sold
  end
end
