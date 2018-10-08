Types::ConversationType = GraphQL::ObjectType.define do
  name 'Conversation'
  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :guid, !types.String
  field :sender, !Types::UserType
  field :recipient, !Types::UserType
  field :messages, types[!Types::MessageType]

  field :unreadCount, types.Int, property: :unread_count
  field :lastMessage, Types::MessageType, property: :last_message

  field :user, Types::UserType do
    resolve -> (obj, _args, ctx) {
      if obj.sender == ctx[:current_user]
        obj.recipient
      else
        obj.sender
      end
    }
  end
end
