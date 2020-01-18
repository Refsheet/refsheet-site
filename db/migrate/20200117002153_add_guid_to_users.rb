class AddGuidToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guid, :string
    add_index :users, :guid
  end
end
