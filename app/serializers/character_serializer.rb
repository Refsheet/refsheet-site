class CharacterSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :name, :url, :shortcode, :profile, :path

  def path
    user_character_path object.user, object
  end
end
