# See: http://jsonapi-rb.org/guides/serialization/defining.html
class Api::V1::UserSerializer < Api::ApiSerializer
  type :user
  id

  attributes :name,
             :username,
             :profile,
             :avatar_url,
             :profile_image_url,
             :is_admin,
             :is_patron,
             :is_supporter,
             :is_moderator
end
