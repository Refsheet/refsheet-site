class AddWatermarkToImages < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_watermarks do |t|
      t.references :user
      t.string :name
      t.integer :images_count
      t.attachment :image
      t.string :gravity
      t.integer :opacity
      t.boolean :repeat_x
      t.boolean :repeat_y

      t.string :guid
      t.datetime :deleted_at
      t.timestamps
    end

    add_column :images, :watermark, :boolean
    add_reference :images, :custom_watermark, foreign_key: true
    add_column :images, :annotation, :boolean
    add_column :images, :custom_annotation, :string

    add_index :custom_watermarks, :guid
  end
end
