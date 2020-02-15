class CreateLodestoneRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :lodestone_races do |t|
      t.string :lodestone_id
      t.string :name

      t.timestamps
    end
    add_index :lodestone_races, :lodestone_id
  end
end
