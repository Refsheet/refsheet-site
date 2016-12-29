class CharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :name, :url, :shortcode, :profile, :path, :user_id

  has_many :swatches, each_serializer: SwatchSerializer

  def path
    user_character_path object.user, object
  end

  def user_id
    object.user.username
  end
end
