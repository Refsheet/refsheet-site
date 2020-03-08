Types::ForumDiscussionCollectionType = GraphQL::ObjectType.define do
  name 'ForumDiscussionCollection'

  interfaces [Interfaces::PaginatedInterface]

  field :discussions, types[Types::ForumDiscussionType] do
    resolve -> (scope, _args, _ctx) { scope }
  end
end