Types::ArtistsCollectionType = GraphQL::ObjectType.define do
  name "ArtistsCollection"

  interfaces [Interfaces::PaginatedInterface]

  field :artists, !types[Types::ArtistType] do
    resolve -> (scope, _args, _ctx) {
      scope
    }
  end
end
