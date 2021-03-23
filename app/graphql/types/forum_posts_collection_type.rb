Types::ForumPostsCollectionType = GraphQL::ObjectType.define do
  name "ForumPostsCollection"

  interfaces [Interfaces::PaginatedInterface]

  field :forumPosts, !types[Types::ForumPostType] do
    resolve -> (scope, _args, _ctx) {
      scope
    }
  end
end
