class CreateArtistsEdits < ActiveRecord::Migration[5.0]
  def change
    create_table :artists_edits do |t|
      t.string :guid
      t.references :user, foreign_key: true
      t.string :summary
      t.text :changes
      t.datetime :approved_at
      t.references :approved_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :artists_edits, :guid
  end
end
