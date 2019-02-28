class CreateCharactersProfileSections < ActiveRecord::Migration[5.0]
  def change
    create_table :characters_profile_sections do |t|
      t.string :guid
      t.references :character
      t.integer :row_order
      t.string :title
      t.string :column_widths

      t.timestamps
    end
    add_index :characters_profile_sections, :guid
    add_index :characters_profile_sections, :row_order
  end
end
