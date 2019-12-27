class CreateMediaHashtags < ActiveRecord::Migration[5.0]
  def change
    create_table :media_hashtags do |t|
      t.string :tag

      t.timestamps
    end
  end
end
