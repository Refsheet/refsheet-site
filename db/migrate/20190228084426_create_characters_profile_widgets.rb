class CreateCharactersProfileWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :characters_profile_widgets do |t|
      t.string :guid
      t.references :character, foreign_key: true
      t.references :profile_section, foreign_key: { to_table: :characters_profile_sections }
      t.integer :column
      t.integer :row_order
      t.string :widget_type
      t.string :title
      t.text :data

      t.timestamps
    end
    add_index :characters_profile_widgets, :guid
    add_index :characters_profile_widgets, :row_order
  end
end
