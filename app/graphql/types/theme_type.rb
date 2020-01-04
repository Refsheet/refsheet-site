Types::ThemeType = GraphQL::ObjectType.define do
  name 'Theme'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :name, types.String

  field :colors, Types::ThemeColorDataType do
    resolve -> (obj, _ctx, _args) {
      obj
    }
  end
end
