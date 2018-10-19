class ClearNsfwProfileImages < ActiveRecord::Migration[5.0]
  class ::Character < ActiveRecord::Base
    belongs_to :profile_image, class_name: "Image"
    belongs_to :featured_image, class_name: "Image"
    has_many :images
  end

  def up
    ::Character.where(profile_image: Image.nsfw).update_all profile_image_id: nil
    ::Character.where(featured_image: Image.nsfw).update_all featured_image_id: nil
  end
end
