class ClearNsfwProfileImages < ActiveRecord::Migration[5.0]
  def up
    Character.where(profile_image: Image.nsfw).update_all profile_image_id: nil
    Character.where(featured_image: Image.nsfw).update_all featured_image_id: nil
  end
end
