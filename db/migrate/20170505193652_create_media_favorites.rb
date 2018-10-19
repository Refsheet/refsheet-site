class CreateMediaFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :media_favorites do |t|
      t.integer :media_id, index: true
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
