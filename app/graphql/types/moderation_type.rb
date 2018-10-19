Types::ModerationType = GraphQL::ObjectType.define do
  name "Moderation"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, types.ID
  field :user, Types::UserType
  field :sender, Types::UserType
  field :comment, types.String
  field :violationType, types.String, property: :violation_type
  field :violationMessage, types.String, property: :violation_message
  field :dmcaSourceUrl, types.String, property: :dmca_source_url
  field :status, types.String, property: :status

  field :itemType, types.String, property: :moderatable_type
  field :itemId, types.ID, property: :moderatable_id
  field :item, Unions::ModerationItemUnion, property: :moderatable
end
