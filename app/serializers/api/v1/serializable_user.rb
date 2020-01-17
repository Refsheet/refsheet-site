# See: http://jsonapi-rb.org/guides/serialization/defining.html
class Api::V1::SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  id { @object.guid }

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

  link :self do
    @url_helpers.user_url(@object.username)
  end
end
