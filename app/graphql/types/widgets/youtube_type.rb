Types::Widgets::YoutubeType = GraphQL::ObjectType.define do
  name 'Youtube'

  field :url, types.String, hash_key: :url
end
