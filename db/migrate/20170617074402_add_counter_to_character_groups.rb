class AddCounterToCharacterGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :character_groups, :characters_count, :integer, null: false, default: 0
    add_column :character_groups, :visible_characters_count, :integer, null: false, default: 0
    add_column :character_groups, :hidden_characters_count, :integer, null: false, default: 0
  end
end
