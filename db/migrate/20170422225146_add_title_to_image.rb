class AddTitleToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :title, :string, after: :artist_id
  end
end
