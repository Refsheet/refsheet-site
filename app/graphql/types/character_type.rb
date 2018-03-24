Types::CharacterType = GraphQL::ObjectType.define do
  name 'Character'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :slug, !types.String
  field :username, !types.String
  field :name, !types.String
  field :species, !types.String
end
