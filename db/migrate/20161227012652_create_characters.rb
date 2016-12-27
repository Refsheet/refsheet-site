class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.string :name
      t.string :url
      t.string :shortcode
      t.text :profile

      t.timestamps
    end
  end
end
