Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # User Mutations
  field :deleteUser, field: Mutations::UserMutations::Delete

  # Images
  field :uploadImage, field: Mutations::ImageMutations::Create

  # Chat
  field :sendMessage, field: Mutations::MessageMutations::Create
  field :updateConversation, field: Mutations::ConversationMutations::Update

  # Moderation
  field :updateModeration, field: Mutations::ModerationMutations::Update

  # Session
  field :createSession, field: Mutations::SessionMutations::Create
  field :destroySession, field: Mutations::SessionMutations::Destroy

  #== Character Profiles

  # Character Mutations
  field :updateCharacter, field: Mutations::CharacterMutations::Update
  field :convertCharacter, field: Mutations::CharacterMutations::Convert

  # Profile Section
  field :updateProfileSection, field: Mutations::ProfileSectionMutations::Update
  field :createProfileSection, field: Mutations::ProfileSectionMutations::Create

  # Profile Widget
  field :updateProfileWidget, field: Mutations::ProfileWidgetMutations::Update
  field :createProfileWidget, field: Mutations::ProfileWidgetMutations::Create
  field :deleteProfileWidget, field: Mutations::ProfileWidgetMutations::Delete
end
