class CreateColorSchemes < ActiveRecord::Migration[5.0]
  def change
    create_table :color_schemes do |t|
      t.string :name
      t.integer :user_id
      t.text :color_data
      t.string :guid

      t.timestamps
    end
  end
end
