Interfaces::ApplicationRecordInterface = GraphQL::InterfaceType.define do
  name 'ApplicationRecord'

  field :id, types.ID do
    resolve -> (obj, _args, _ctx) {
      obj.attributes['guid'] || obj.attributes['uuid'] || obj.id
    }
  end

  field :created_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.created_at&.to_i if obj.respond_to? :created_at
    }
  end

  field :updated_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.updated_at&.to_i if obj.respond_to? :updated_at
    }
  end

  field :deleted_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.deleted_at&.to_i if obj.respond_to? :deleted_at
    }
  end
end
