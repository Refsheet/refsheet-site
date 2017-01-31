class CreateSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :slots do |t|
      t.integer :item_id
      t.integer :extends_slot_id
      t.string :title
      t.text :description
      t.string :color
      t.monetize :amount
      t.boolean :requires_character

      t.timestamps
    end
  end
end
