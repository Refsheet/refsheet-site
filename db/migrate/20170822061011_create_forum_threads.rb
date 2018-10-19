class CreateForumThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_threads do |t|
      t.integer :forum_id
      t.integer :user_id
      t.integer :character_id
      t.string :topic
      t.string :slug
      t.string :shortcode
      t.text :content
      t.boolean :locked
      t.integer :karma_total

      t.timestamps
    end
    add_index :forum_threads, :forum_id
    add_index :forum_threads, :user_id
    add_index :forum_threads, :character_id
    add_index :forum_threads, :slug
    add_index :forum_threads, :shortcode
    add_index :forum_threads, :karma_total
  end
end
