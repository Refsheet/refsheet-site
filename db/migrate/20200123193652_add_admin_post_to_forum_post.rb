class AddAdminPostToForumPost < ActiveRecord::Migration[5.2]
  def change
    add_column :forum_posts, :admin_post, :boolean, default: false
    add_column :forum_posts, :moderator_post, :boolean, default: false
  end
end
