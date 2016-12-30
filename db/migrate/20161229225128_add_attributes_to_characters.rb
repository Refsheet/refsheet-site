class AddAttributesToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :gender, :string
    add_column :characters, :species, :string
    add_column :characters, :height, :string
    add_column :characters, :weight, :string
    add_column :characters, :body_type, :string
    add_column :characters, :personality, :string
    add_column :characters, :special_notes, :text
    add_column :characters, :featured_image_id, :integer
    add_column :characters, :profile_image_id, :integer
  end
end
