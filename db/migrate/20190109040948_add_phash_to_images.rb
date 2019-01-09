class AddPhashToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :image_phash, 'bit(64)'
  end
end
