class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :guid
      t.string :name
      t.string :slug
      t.string :commission_url
      t.string :website_url
      t.text :profile
      t.text :profile_markdown
      t.text :commission_info
      t.text :commission_info_markdown
      t.boolean :locked
      t.integer :media_count
      t.references :user, index: true

      t.timestamps
    end

    add_index :artists, :guid
    add_index :artists, :slug
  end
end
