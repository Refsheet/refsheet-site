class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.integer :item_id
      t.integer :slot_id
      t.monetize :starting_bid
      t.monetize :minimum_increase
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
