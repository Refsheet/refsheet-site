class AddImageDirectToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :image_processing, :boolean, default: false
    add_column :images, :image_direct_upload_url, :string
  end
end
