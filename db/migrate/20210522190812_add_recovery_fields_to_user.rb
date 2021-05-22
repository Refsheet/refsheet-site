class AddRecoveryFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_confirmation_token, :string
    add_column :users, :email_confirmation_created_at, :datetime
    add_column :users, :account_recovery_token, :string
    add_column :users, :account_recovery_created_at, :datetime
    add_column :users, :otp_login_token, :string
    add_column :users, :otp_login_created_at, :datetime
    add_column :users, :email_change_token, :string
    add_column :users, :email_change_created_at, :datetime

    add_index :users, :email_confirmation_token
    add_index :users, :account_recovery_token
    add_index :users, :otp_login_token
    add_index :users, :email_change_token
  end
end
