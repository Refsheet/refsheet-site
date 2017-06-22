class AddAuthCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth_code_digest, :string
    add_column :invitations, :auth_code_digest, :string
  end
end
