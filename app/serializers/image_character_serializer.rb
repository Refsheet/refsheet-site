class ImageCharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :username,
             :name,
             :species,
             :gender,
             :slug,
             :profile_image_url,
             :featured_image_url,
             :group_ids,
             :path,
             :link

  has_one :color_scheme, serializer: ColorSchemeSerializer

  def username
    object.user.username
  end

  def path
    user_character_path object.user, object
  end

  def group_ids
    object.character_groups.collect(&:slug)
  end

  def profile_image_url
    object.profile_image&.image&.url(:thumbnail)
  end

  def featured_image_url
    object.featured_image&.image&.url(:large)
  end

  def link
    "/#{object.user.username}/#{object.slug}"
  end
end
