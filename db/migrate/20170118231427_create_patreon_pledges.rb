class CreatePatreonPledges < ActiveRecord::Migration[5.0]
  def change
    create_table :patreon_pledges do |t|
      t.string :patreon_id
      t.integer :amount_cents
      t.datetime :declined_since
      t.boolean :patron_pays_fees
      t.integer :pledge_cap_cents
      t.integer :patreon_reward_id
      t.integer :patreon_patron_id

      t.timestamps
    end
  end
end
