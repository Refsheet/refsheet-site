class AddParanoidToForumPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :forum_posts, :deleted_at, :datetime
    add_index :forum_posts, :deleted_at
    add_column :forum_posts, :edited, :boolean, default: false
  end
end
