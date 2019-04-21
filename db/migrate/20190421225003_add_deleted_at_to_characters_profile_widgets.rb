class AddDeletedAtToCharactersProfileWidgets < ActiveRecord::Migration[5.0]
  def change
    add_column :characters_profile_widgets, :deleted_at, :datetime
    add_index :characters_profile_widgets, :deleted_at
  end
end
