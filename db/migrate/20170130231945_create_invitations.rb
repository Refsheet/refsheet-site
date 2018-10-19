class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :email
      t.datetime :seen_at
      t.datetime :claimed_at

      t.timestamps
    end
  end
end
