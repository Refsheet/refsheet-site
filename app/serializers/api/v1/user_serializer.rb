# See: http://jsonapi-rb.org/guides/serialization/defining.html
class Api::V1::UserSerializer < Panko::Serializer
  aliases guid: :id

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
