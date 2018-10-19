class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :slot_id
      t.integer :auction_id

      t.timestamps
    end
  end
end
