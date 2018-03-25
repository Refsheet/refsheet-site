Types::Widgets::JsonType = GraphQL::ObjectType.define do
  field :json, types.String do
    resolve -> (obj, _args, _ctx) {
      obj.to_json
    }
  end
end
