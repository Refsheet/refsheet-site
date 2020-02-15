class CreateLodestoneClassJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :lodestone_class_jobs do |t|
      t.references :lodestone_character
      t.string :name
      t.string :class_abbr
      t.string :class_icon_url
      t.string :class_name
      t.string :job_abbr
      t.string :job_icon_url
      t.string :job_name
      t.integer :level
      t.integer :exp_level
      t.integer :exp_level_max
      t.integer :exp_level_togo
      t.boolean :specialized
      t.boolean :job_active

      t.timestamps
    end
    add_index :lodestone_class_jobs, :name
  end
end
