class AddParanoiaToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :deleted_at, :datetime
  end
end
