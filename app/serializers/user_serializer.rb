class UserSerializer < ActiveModel::Serializer
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url

  def avatar_url
    gravatar_image_url object.email
  end
end
