class CreateArtistsReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :artists_reviews do |t|
      t.string :guid
      t.references :artist, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps
    end
    add_index :artists_reviews, :guid
  end
end
