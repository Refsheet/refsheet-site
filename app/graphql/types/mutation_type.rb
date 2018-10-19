Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :updateCharacter, field: Mutations::CharacterMutations::Update
  field :updateModeration, field: Mutations::ModerationMutations::Update
  field :uploadImage, field: Mutations::ImageMutations::Create

  field :sendMessage, field: Mutations::MessageMutations::Create
  field :updateConversation, field: Mutations::ConversationMutations::Update
end
