Types::ConversationType = GraphQL::ObjectType.define do
  name 'Conversation'

  field :id, !types.ID
  field :guid, !types.String
  field :sender, !Types::UserType
  field :recipient, !Types::UserType
  field :messages, types[!Types::MessageType]

  field :unreadCount, types.Int, property: :unread_count
  field :lastMessage, Types::MessageType, property: :last_message
end
