Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :updateCharacter, field: Mutations::CharacterMutations::Update
end
