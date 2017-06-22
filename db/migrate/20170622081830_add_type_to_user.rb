class AddTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :type, :string
    add_index :users, :type
  end
end
