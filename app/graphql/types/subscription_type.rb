Types::SubscriptionType = GraphQL::ObjectType.define do
  name "Subscription"

  field :characterChanged, !Types::CharacterType do
    argument :id, !types.String
    description "Character information has changed"
  end
end
