Types::ConversationType = GraphQL::ObjectType.define do
  name 'Conversation'

  field :id, !types.ID
  field :guid, !types.String
  field :sender, !Types::UserType
  field :recipient, !Types::UserType
  field :messages, types[!Types::MessageType]
end
