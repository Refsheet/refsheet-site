class UserSerializer < ActiveModel::Serializer
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url, :path, :name

  has_many :characters, serializer: ImageCharacterSerializer

  def avatar_url
    gravatar_image_url object.email
  end

  def path
    '/users/' + object.username + '/'
  end
end
