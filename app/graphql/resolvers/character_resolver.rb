class Resolvers::CharacterResolver < GraphQL::Function
  argument :id, types.String
  argument :userName, types.String
  argument :slug, types.String

  type do
    name 'Character'
    field :id, types.String
    field :name, types.String
  end
end
