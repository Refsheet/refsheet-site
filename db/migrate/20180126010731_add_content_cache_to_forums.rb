class AddContentCacheToForums < ActiveRecord::Migration[5.0]
  def change
    add_column :forum_threads, :content_html, :string
    add_column :forum_posts, :content_html, :string
  end
end
