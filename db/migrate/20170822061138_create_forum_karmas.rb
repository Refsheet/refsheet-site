class CreateForumKarmas < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_karmas do |t|
      t.integer :karmic_id
      t.integer :karmic_type
      t.integer :user_id
      t.boolean :discord

      t.timestamps
    end
    add_index :forum_karmas, :karmic_id
    add_index :forum_karmas, :karmic_type
  end
end
