Types::MessageType = GraphQL::ObjectType.define do
  name 'Message'
  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :guid, !types.String
  field :user, !Types::UserType
  field :message, types.String

  field :replyTo, -> { Types::MessageType }
  field :conversation, -> { Types::ConversationType }

  field :read_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.read_at&.to_i
    }
  end

  field :is_self, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.user_id == ctx[:current_user].id
    }
  end
end
