class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.integer :character_id
      t.integer :item_id
      t.integer :sender_user_id
      t.integer :destination_user_id
      t.integer :invitation_id
      t.datetime :seen_at
      t.datetime :claimed_at
      t.datetime :rejected_at
      t.string :status

      t.timestamps
    end
  end
end
