class AddPostCountToDiscussions < ActiveRecord::Migration[6.0]
  def change
    add_column :forum_threads, :posts_count, :integer, default: 0, null: false
  end
end
