Types::SessionType = GraphQL::ObjectType.define do
  name 'Session'

  field :sessionId, types.String, hash_key: :session_id
  field :nsfwOk, types.Boolean, hash_key: :nsfw_ok
  field :locale, types.String, hash_key: :locale
  field :timeZone, types.String, hash_key: :time_zone
  field :currentUser, Types::UserType, hash_key: :current_user
end
