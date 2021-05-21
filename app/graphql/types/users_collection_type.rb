Types::UsersCollectionType = GraphQL::ObjectType.define do
  name "UsersCollection"

  interfaces [Interfaces::PaginatedInterface]

  field :users, !types[Types::UserType] do
    resolve -> (scope, _args, _ctx) {
      scope
    }
  end
end
