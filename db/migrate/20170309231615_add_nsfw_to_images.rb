class AddNsfwToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :nsfw, :boolean
    add_column :images, :hidden, :boolean
    add_column :images, :gallery_id, :integer
  end
end
