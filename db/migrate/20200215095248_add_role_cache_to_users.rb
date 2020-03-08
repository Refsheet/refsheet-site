class AddRoleCacheToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :patron, :boolean
    add_column :users, :supporter, :boolean
    add_column :users, :moderator, :boolean
  end
end
