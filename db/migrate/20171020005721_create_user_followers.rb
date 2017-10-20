class CreateUserFollowers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_followers do |t|
      t.integer :following_id
      t.integer :follower_id

      t.timestamps
    end

    add_index :user_followers, :following_id
    add_index :user_followers, :follower_id
  end
end
