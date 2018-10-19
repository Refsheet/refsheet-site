class AddAuthCodeToPatreonPatrons < ActiveRecord::Migration[5.0]
  def change
    add_column :patreon_patrons, :auth_code_digest, :string
    add_column :patreon_patrons, :pending_user_id, :integer
  end
end
