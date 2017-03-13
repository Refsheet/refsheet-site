class AddNsfwToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :nsfw, :boolean
    add_column :characters, :hidden, :boolean
    add_column :characters, :secret, :boolean
  end
end
