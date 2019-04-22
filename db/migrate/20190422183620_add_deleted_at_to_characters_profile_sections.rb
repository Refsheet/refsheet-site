class AddDeletedAtToCharactersProfileSections < ActiveRecord::Migration[5.0]
  def change
    add_column :characters_profile_sections, :deleted_at, :datetime
    add_index :characters_profile_sections, :deleted_at
  end
end
