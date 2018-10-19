class CreateOrganizationMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_memberships do |t|
      t.integer :user_id
      t.integer :organization_id
      t.boolean :admin

      t.timestamps
    end
    add_index :organization_memberships, :user_id
    add_index :organization_memberships, :organization_id
    add_index :organization_memberships, :admin
  end
end
