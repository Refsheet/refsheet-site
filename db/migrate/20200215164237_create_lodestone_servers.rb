class CreateLodestoneServers < ActiveRecord::Migration[6.0]
  def change
    create_table :lodestone_servers do |t|
      t.string :lodestone_id
      t.string :name
      t.string :datacenter
      t.integer :characters_count

      t.timestamps
    end
    add_index :lodestone_servers, :lodestone_id
  end
end
