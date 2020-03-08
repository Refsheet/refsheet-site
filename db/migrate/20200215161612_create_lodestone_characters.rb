class CreateLodestoneCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :lodestone_characters do |t|
      t.references :active_class_job
      t.text :bio
      t.references :server
      t.string :lodestone_id
      t.string :name
      t.string :nameday
      t.datetime :remote_updated_at
      t.string :portrait_url
      t.references :race
      t.string :title
      t.boolean :title_top
      t.string :town
      t.string :tribe
      t.string :diety
      t.string :gc_name
      t.string :gc_rank_name

      t.timestamps
    end
    add_index :lodestone_characters, :lodestone_id
  end
end
