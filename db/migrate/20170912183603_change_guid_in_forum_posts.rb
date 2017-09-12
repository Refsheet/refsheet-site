class ChangeGuidInForumPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :forum_posts, :guid, :string
  end
end
