class Api::V1::SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :username,
             :avatar_url,
             :name,
             :profile_image_url,
             :profile,
             :characters_count,
             :is_admin,
             :is_patron,
             :is_supporter,
             :is_moderator
end
