class AddGuidToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :guid, :string
    add_index :characters, :guid
  end
end
