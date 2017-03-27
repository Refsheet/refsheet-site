class CreateChangelogs < ActiveRecord::Migration[5.0]
  def change
    create_table :changelogs do |t|
      t.integer :user_id
      t.integer :changed_character_id
      t.integer :changed_user_id
      t.integer :changed_image_id
      t.integer :changed_swatch_id
      t.text :reason
      t.json :change_data

      t.timestamps
    end
  end
end
