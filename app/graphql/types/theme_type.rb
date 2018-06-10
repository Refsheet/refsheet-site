Types::ThemeType = GraphQL::ObjectType.define do
  name 'Theme'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :name, types.String
  field :colors, Types::ThemeColorDataType, property: :color_data
end
