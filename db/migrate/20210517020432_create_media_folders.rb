class CreateMediaFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :media_folders do |t|
      t.belongs_to :parent_media_folder, foreign_key: { to_table: :media_folders }
      t.belongs_to :user, foreign_key: true
      t.belongs_to :character, foreign_key: true
      t.integer :media_count
      t.boolean :hidden
      t.boolean :nsfw
      t.integer :row_order
      t.string :name
      t.text :description
      t.string :guid
      t.string :slug
      t.string :password
      t.belongs_to :featured_media, foreign_key: { to_table: :images }

      t.timestamps
    end

    add_index :media_folders, :guid
    add_index :media_folders, :slug
  end
end
