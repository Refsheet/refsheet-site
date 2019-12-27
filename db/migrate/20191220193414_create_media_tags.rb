class CreateMediaTags < ActiveRecord::Migration[5.0]
  def change
    create_table :media_tags do |t|
      t.belongs_to :media, foreign_key: { to_table: :images }
      t.belongs_to :character, foreign_key: true
      t.integer :position_x
      t.integer :position_y

      t.timestamps
    end
  end
end
