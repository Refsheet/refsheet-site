Types::ConversationType = GraphQL::ObjectType.define do
  name 'Conversation'
  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :guid, !types.String
  field :sender, !Types::UserType
  field :recipient, !Types::UserType
  field :messages, types[!Types::MessageType]

  field :unreadCount, types.Int do
    resolve -> (obj, _args, ctx) {
      obj.unread_count(ctx[:current_user].call)
    }
  end

  field :lastMessage, Types::MessageType, property: :last_message

  field :user, Types::UserType do
    resolve -> (obj, _args, ctx) {
      obj.recipient_for(ctx[:current_user].call)
    }
  end

  field :blocked, types.Boolean do
    resolve -> (obj, _args, ctx) {
      cu = ctx[:current_user].call
      ru = obj.recipient_for(cu)

      cu.blocked?(ru) || ru.blocked?(cu)
    }
  end
end
