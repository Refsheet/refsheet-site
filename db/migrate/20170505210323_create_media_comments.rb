class CreateMediaComments < ActiveRecord::Migration[5.0]
  def change
    create_table :media_comments do |t|
      t.integer :media_id
      t.integer :user_id
      t.integer :reply_to_comment_id
      t.text :comment

      t.timestamps
    end

    add_index :media_comments, :media_id
    add_index :media_comments, :user_id
    add_index :media_comments, :reply_to_comment_id
  end
end
