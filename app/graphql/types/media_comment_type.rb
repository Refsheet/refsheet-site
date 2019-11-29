Types::MediaCommentType = GraphQL::ObjectType.define do
  name "MediaComment"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :comment, !types.String
  field :user, Types::UserType
end