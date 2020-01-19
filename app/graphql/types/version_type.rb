Types::VersionType = GraphQL::ObjectType.define do
  name 'Version'

  interfaces [Interfaces::ApplicationRecordInterface]


  field :item_type, !types.String
  field :item_id, !types.Int
  field :index, types.Int
  field :event, !types.String
  field :whodunnit, Types::UserType

  field :was_me, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.whodunnit == ctx[:current_user].call
    }
  end

  field :object, types.String do
    resolve -> (obj, _args, _ctx) {
      obj.object.to_json
    }
  end

  field :object_changes, types.String do
    resolve -> (obj, _args, _ctx) {
      obj.object_changes.to_json
    }
  end
end
