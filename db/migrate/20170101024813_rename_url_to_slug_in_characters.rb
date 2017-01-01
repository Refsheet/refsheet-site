class RenameUrlToSlugInCharacters < ActiveRecord::Migration[5.0]
  def change
    rename_column :characters, :url, :slug
  end
end
