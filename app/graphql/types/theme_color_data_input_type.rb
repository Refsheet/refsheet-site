Types::ThemeColorDataInputType = GraphQL::InputObjectType.define do
  name 'ThemeColorDataInput'

  argument :primary, types.String
  argument :accent1, types.String
  argument :accent2, types.String
  argument :background, types.String
  argument :cardBackground, types.String
  argument :imageBackground, types.String
  argument :text, types.String
  argument :textLight, types.String
  argument :textMedium, types.String
end
