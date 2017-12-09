class CreateForumSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_subscriptions do |t|
      t.integer :discussion_id
      t.integer :user_id
      t.datetime :last_read_at

      t.timestamps
    end
    add_index :forum_subscriptions, :discussion_id
    add_index :forum_subscriptions, :user_id
  end
end
