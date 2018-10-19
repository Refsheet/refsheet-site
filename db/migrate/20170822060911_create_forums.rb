class CreateForums < ActiveRecord::Migration[5.0]
  def change
    create_table :forums do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.boolean :locked
      t.boolean :nsfw
      t.boolean :no_rp

      t.timestamps
    end
    add_index :forums, :slug
  end
end
