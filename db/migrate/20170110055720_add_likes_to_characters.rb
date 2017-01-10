class AddLikesToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :likes, :text
    add_column :characters, :dislikes, :text
  end
end
