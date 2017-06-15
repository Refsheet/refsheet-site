class CreateCharacterGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :character_groups do |t|
      t.integer :user_id
      t.string :name
      t.string :slug
      t.integer :row_order
      t.boolean :hidden

      t.timestamps
    end

    add_index :character_groups, :user_id
    add_index :character_groups, :slug
  end
end
