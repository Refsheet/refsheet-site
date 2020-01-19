Types::ThemeColorDataType = GraphQL::ObjectType.define do
  name 'ThemeColorData'

  field :primary, types.String
  field :accent1, types.String
  field :accent2, types.String
  field :background, types.String
  field :cardBackground, types.String
  field :imageBackground, types.String
  field :text, types.String
  field :textLight, types.String
  field :textMedium, types.String
end
