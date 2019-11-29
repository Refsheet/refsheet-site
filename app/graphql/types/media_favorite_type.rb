Types::MediaFavoriteType = GraphQL::ObjectType.define do
  name "MediaFavorite"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :user, Types::UserType
end