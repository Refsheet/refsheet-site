class CreateConversationsMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations_messages do |t|
      t.references :conversation, index: true
      t.references :user, index: true
      t.text :message
      t.references :reply_to
      t.timestamp :read_at
      t.timestamp :deleted_at
      t.string :guid

      t.timestamps
    end

    add_index :conversations_messages, :guid
  end
end
