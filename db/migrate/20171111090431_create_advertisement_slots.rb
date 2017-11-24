class CreateAdvertisementSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisement_slots do |t|
      t.integer :active_campaign_id
      t.integer :reserved_campaign_id
      t.integer :last_impression_at

      t.timestamps
    end
    add_index :advertisement_slots, :active_campaign_id
    add_index :advertisement_slots, :reserved_campaign_id
    add_index :advertisement_slots, :last_impression_at
  end
end
