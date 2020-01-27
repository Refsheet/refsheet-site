Types::TransferType = GraphQL::ObjectType.define do
  name 'Transfer'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
end
