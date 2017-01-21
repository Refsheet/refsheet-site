class CreatePatreonRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :patreon_rewards do |t|
      t.string :patreon_id
      t.integer :amount_cents
      t.text :description
      t.string :image_url
      t.boolean :requires_shipping
      t.string :title
      t.string :url
      t.boolean :grants_badge

      t.timestamps
    end
  end
end
