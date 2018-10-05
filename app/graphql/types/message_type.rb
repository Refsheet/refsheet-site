Types::MessageType = GraphQL::ObjectType.define do
  name 'Message'

  field :id, !types.ID
  field :guid, !types.String
  field :user, !Types::UserType
  field :message, types.String

  field :replyTo, -> { Types::MessageType }
  field :conversation, -> { Types::ConversationType }
end
