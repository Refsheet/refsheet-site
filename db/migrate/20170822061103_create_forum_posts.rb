class CreateForumPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_posts do |t|
      t.integer :thread_id
      t.integer :user_id
      t.integer :character_id
      t.integer :parent_post_id
      t.integer :guid
      t.text :content
      t.integer :karma_total

      t.timestamps
    end
    add_index :forum_posts, :thread_id
    add_index :forum_posts, :user_id
    add_index :forum_posts, :character_id
    add_index :forum_posts, :parent_post_id
    add_index :forum_posts, :guid
  end
end
