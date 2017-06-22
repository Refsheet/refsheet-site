class UserSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag::InstanceMethods

  attributes :username,
             :avatar_url,
             :path,
             :link,
             :name,
             :profile_image_url,
             :profile,
             :profile_markup,
             :characters_count,
             :is_admin,
             :is_patron

  has_many :characters,
           serializer: ImageCharacterSerializer

  has_many :character_groups,
           serializer: CharacterGroupSerializer

  def characters
    object.characters.rank(:row_order)
  end

  def characters_count
    object.characters.count
  end

  def path
    "/users/#{object.username}/"
  end

  def link
    "/#{object.username}"
  end

  def profile_markup
    object.profile || ''
  end

  def profile
    linkify profile_markup
  end

  def is_admin
    object.role? :admin
  end

  def is_patron
    object.pledges.active.any?
  end

  def settings
    object.settings.as_json
  end
end
