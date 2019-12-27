Types::SubscriptionType = GraphQL::ObjectType.define do
  name "Subscription"

  field :characterChanged, !Types::CharacterType do
    argument :id, !types.String
    description "Character information has changed"
  end

  field :newMessage, !Types::MessageType do
    argument :conversationId, !types.ID
    subscription_scope :current_user_id
    description "New message published"
  end

  field :convChanged, !Types::ConversationType do
    argument :convId, !types.ID
    subscription_scope :current_user_id
    description "Conversation changed somehow"
  end

  field :newConversation, !Types::ConversationType do
    subscription_scope :current_user_id
    description "Conversation changed somehow"
  end

  field :chatCountsChanged, Types::ChatCountType do
    subscription_scope :current_user_id
    description "Conversation counts changed"
  end

  field :imageProcessingComplete, Types::ImageType do
    argument :imageId, !types.ID
    description "Image processing complete"
  end

  field :newNotification, !Types::NotificationType do
    subscription_scope :current_user_id
    description "New notifications go here"
  end

  #== Media

  field :newFavorite, !Types::MediaFavoriteType do
    argument :mediaId, !types.ID
    description "New favorite on media"
  end

  field :newComment, !Types::MediaCommentType do
    argument :mediaId, !types.ID
    description "New comment on media"
  end
end
