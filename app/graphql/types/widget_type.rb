Types::WidgetType = GraphQL::ObjectType.define do
  name 'Widget'

  field :id, !types.ID
  field :type, !types.String
  field :column, !types.Int
  field :title, types.String

  field :data, Unions::WidgetDataUnion do
    resolve -> (obj, _args, _ctx) {
      data = obj.data.dup
      data[:_data_type] = obj.type
      data
    }
  end

end
