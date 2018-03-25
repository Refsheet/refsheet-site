Types::AttributeType = GraphQL::ObjectType.define do
  name 'Attribute'

  field :id, !types.String, hash_key: :id
  field :name, types.String, hash_key: :name
  field :value, !types.String, hash_key: :value
end
