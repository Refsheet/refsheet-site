class CreateBlockedUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :blocked_users do |t|
      t.references :user, foreign_key: true
      t.references :blocked_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
