class CreateCharacterGroupsCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :character_groups_characters, id: false do |t|
      t.integer :character_group_id
      t.integer :character_id
    end

    add_index :character_groups_characters, :character_group_id
    add_index :character_groups_characters, :character_id
  end
end
