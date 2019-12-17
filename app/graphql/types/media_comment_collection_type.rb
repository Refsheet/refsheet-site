Types::MediaCommentCollectionType = GraphQL::ObjectType.define do
  name "MediaCommentCollection"

  interfaces [Interfaces::PaginatedInterface]

  field :comments, types[Types::MediaCommentType] do
    resolve -> (scope, _args, _ctx) {
      scope
    }
  end
end
