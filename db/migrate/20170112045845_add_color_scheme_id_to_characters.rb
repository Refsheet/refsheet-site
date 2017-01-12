class AddColorSchemeIdToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :color_scheme_id, :integer
  end
end
