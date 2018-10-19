class AddEmailConfirmationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unconfirmed_email, :string
    add_column :users, :email_confirmed_at, :datetime
  end
end
