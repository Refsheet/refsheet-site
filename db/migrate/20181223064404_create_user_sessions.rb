class CreateUserSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, foreign_key: true
      t.references :ahoy_visit, foreign_key: true
      t.string :session_guid
      t.string :session_token_digest

      t.timestamps
    end
    add_index :user_sessions, :session_guid
  end
end
