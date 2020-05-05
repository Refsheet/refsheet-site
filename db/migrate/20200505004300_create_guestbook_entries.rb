class CreateGuestbookEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :guestbook_entries do |t|
      t.references :character, foreign_key: true
      t.references :author_user, foreign_key: { to_table: :users }
      t.references :author_character, foreign_key: { to_table: :characters }
      t.text :message
      t.datetime :deleted_at
      t.string :guid

      t.timestamps
    end
    add_index :guestbook_entries, :deleted_at
    add_index :guestbook_entries, :guid
  end
end
