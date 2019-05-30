class AddSystemToForums < ActiveRecord::Migration[5.0]
  def change
    add_column :forums, :system_owned, :boolean, default: false
    add_index :forums, :system_owned
  end
end
