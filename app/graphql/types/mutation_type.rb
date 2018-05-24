Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :updateCharacter, field: Mutations::CharacterMutations::Update
  field :updateModeration, field: Mutations::ModerationMutations::Update
end
