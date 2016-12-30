class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :character_id
      t.integer :artist_id
      t.string :caption
      t.string :source_url
      t.attachment :image

      t.timestamps
    end
  end
end
