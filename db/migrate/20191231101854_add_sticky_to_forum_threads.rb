class AddStickyToForumThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :forum_threads, :sticky, :boolean
    add_index :forum_threads, :sticky
    add_column :forum_threads, :admin_post, :boolean
    add_column :forum_threads, :moderator_post, :boolean
  end
end
