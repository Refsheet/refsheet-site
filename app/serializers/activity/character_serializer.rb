class Activity::CharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :species,
             :gender,
             :slug,
             :profile_image_url,
             :featured_image_url,
             :path,
             :link

  def id
    object.shortcode
  end

  def profile_image_url
    object.profile_image&.image&.url(:thumbnail)
  end

  def featured_image_url
    object.featured_image&.image&.url(:large)
  end

  def path
    user_character_path object.user, object
  end

  def link
    "/#{object.user.username}/#{object.slug}"
  end
end
