class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :guid
      t.integer :user_id
      t.integer :character_id
      t.string :activity_type
      t.integer :activity_id
      t.string :activity_method
      t.string :activity_field

      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, :character_id
    add_index :activities, :activity_type
  end
end
