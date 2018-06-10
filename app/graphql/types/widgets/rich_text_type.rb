Types::Widgets::RichTextType = GraphQL::ObjectType.define do
  name 'RichText'

  field :content, types.String, hash_key: :content
  field :content_html, types.String, hash_key: :content_html
end
