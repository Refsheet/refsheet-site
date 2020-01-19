Types::MediaHashtagType = GraphQL::ObjectType.define do
  name "MediaHashtag"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :tag, types.String
  field :media, Types::ImageType
  field :count, types.Int
end