class CreateArtistsLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :artists_links do |t|
      t.string :guid
      t.references :artist, foreign_key: true
      t.string :url
      t.references :submitted_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_at
      t.string :favicon_url

      t.timestamps
    end
  end
end
