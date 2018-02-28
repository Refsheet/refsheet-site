class AddGuidToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :guid, :string
    add_index :notifications, :guid
  end
end
