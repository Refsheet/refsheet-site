Types::ThemeColorDataType = GraphQL::ObjectType.define do
  name 'ThemeColorData'

  field :primary, types.String, hash_key: 'primary'
  field :accent1, types.String, hash_key: 'accent1'
  field :accent2, types.String, hash_key: 'accent2'
  field :background, types.String, hash_key: 'background'
  field :cardBackground, types.String, hash_key: 'card-background'
  field :imageBackground, types.String, hash_key: 'image-background'
  field :text, types.String, hash_key: 'text'
  field :textLight, types.String, hash_key: 'text-light'
  field :textMedium, types.String, hash_key: 'text-medium'
end
