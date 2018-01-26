class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :character_id
      t.integer :sender_user_id
      t.integer :sender_character_id
      t.string :type
      t.integer :actionable_id
      t.string :actionable_type
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :character_id
    add_index :notifications, :type
  end
end
