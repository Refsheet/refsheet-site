class CreateJoinTableImagesMediaHashtags < ActiveRecord::Migration[5.0]
  def change
    create_join_table :images, :media_hashtags do |t|
       t.index [:image_id, :media_hashtag_id]
       t.index [:media_hashtag_id, :image_id]
    end
  end
end
