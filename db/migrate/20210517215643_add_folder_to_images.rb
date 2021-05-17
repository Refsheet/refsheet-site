class AddFolderToImages < ActiveRecord::Migration[6.0]
  def change
    add_reference :images, :media_folder, foreign_key: true
  end
end
