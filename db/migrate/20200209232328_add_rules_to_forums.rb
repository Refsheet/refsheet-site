class AddRulesToForums < ActiveRecord::Migration[6.0]
  def change
    add_column :forums, :rules, :text
    add_column :forums, :prepost_message, :text
    add_column :forums, :owner_id, :integer
    add_index :forums, :owner_id
    add_column :forums, :fandom_id, :integer
    add_index :forums, :fandom_id
    add_column :forums, :open, :boolean, default: :false
  end
end
