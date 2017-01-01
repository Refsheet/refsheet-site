class UserSerializer < ActiveModel::Serializer
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url, :path

  has_many :characters, serializer: UserCharactersSerializer

  def avatar_url
    gravatar_image_url object.email
  end

  def path
    '/users/' + object.username + '/'
  end
end
