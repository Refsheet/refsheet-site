class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.references :sender, index: true
      t.references :recipient, index: true
      t.boolean :approved
      t.string :subject
      t.boolean :muted
      t.string :guid
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :conversations, :guid
  end
end
