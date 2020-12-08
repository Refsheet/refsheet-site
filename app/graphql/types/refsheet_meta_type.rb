Types::RefsheetMetaType = GraphQL::ObjectType.define do
  name 'RefsheetMeta'

  field :version, type: types.String, hash_key: :version
end
