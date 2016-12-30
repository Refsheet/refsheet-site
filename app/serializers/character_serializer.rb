class CharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :name, :url, :shortcode, :profile, :path, :user_id, :gender,
             :species, :height, :weight, :body_type, :personality, :special_notes

  has_many :swatches, each_serializer: SwatchSerializer
  has_one  :featured_image, serializer: CharacterImageSerializer
  has_one  :profile_image, serializer: CharacterImageSerializer

  def path
    user_character_path object.user, object
  end

  def user_id
    object.user.username
  end
end
