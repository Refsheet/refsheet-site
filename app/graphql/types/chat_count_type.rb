Types::ChatCountType = GraphQL::ObjectType.define do
  name 'ChatCount'

  field :unread, types.Int, hash_key: :unread
end
