Types::MediaTagType = GraphQL::ObjectType.define do
  name "MediaTag"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :character, Types::CharacterType
  field :media, Types::ImageType
  field :position_x, types.Int
  field :position_y, types.Int
end