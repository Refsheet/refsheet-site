class ImageCharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :username, :name, :slug, :path, :profile_image_url

  def username
    object.user.username
  end

  def path
    user_character_path object.user, object
  end

  def profile_image_url
    object.profile_image&.image.url
  end
end
