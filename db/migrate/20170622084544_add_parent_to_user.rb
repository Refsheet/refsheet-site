class AddParentToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :parent_user_id, :integer
    add_index :users, :parent_user_id
  end
end
