Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # User Mutations
  field :deleteUser, field: Mutations::UserMutations::Delete

  # Character Mutations
  field :updateCharacter, field: Mutations::CharacterMutations::Update

  # Images
  field :uploadImage, field: Mutations::ImageMutations::Create

  # Chat
  field :sendMessage, field: Mutations::MessageMutations::Create
  field :updateConversation, field: Mutations::ConversationMutations::Update

  # Moderation
  field :updateModeration, field: Mutations::ModerationMutations::Update
end
