class CreateConversationsReadBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations_read_bookmarks do |t|
      t.references :conversation, foreign_key: true
      t.references :message, foreign_key: { to_table: :conversations_messages }
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
