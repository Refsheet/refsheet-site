class FixSlots < ActiveRecord::Migration[5.0]
  def change
    remove_column :advertisement_slots, :last_impression_at
    add_column :advertisement_slots, :last_impression_at, :datetime
    add_column :advertisement_campaigns, :slots_requested, :integer, default: 1
  end
end
