class CreateSwatches < ActiveRecord::Migration[5.0]
  def change
    create_table :swatches do |t|
      t.integer :character_id
      t.string :name
      t.string :color
      t.text :notes
      t.integer :row_order
      t.string :guid

      t.timestamps
    end
  end
end
