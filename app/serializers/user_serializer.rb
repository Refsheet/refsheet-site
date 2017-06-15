class UserSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag::InstanceMethods

  attributes :username,
             :email,
             :avatar_url,
             :path,
             :link,
             :name,
             :profile_image_url,
             :profile,
             :profile_markup,
             :is_admin,
             :is_patron,
             :settings,
             :id

  has_many :characters,
           serializer: ImageCharacterSerializer

  def characters
    object.characters.default_order
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
