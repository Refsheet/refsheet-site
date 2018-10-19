require_dependency Rails.root.join 'app/serializers/activity/image_serializer'
require_dependency Rails.root.join 'app/serializers/activity/character_serializer'
require_dependency Rails.root.join 'app/serializers/activity/discussion_serializer'
require_dependency Rails.root.join 'app/serializers/activity/comment_serializer'
require_dependency Rails.root.join 'app/serializers/activity/favorite_serializer'
require_dependency Rails.root.join 'app/serializers/activity/user_serializer'

class NotificationSerializer < ApplicationSerializer
  attributes :id,
             :type,
             :title,
             :message,
             :href,
             :tag,
             :actionable_type,
             :actionable,
             :timestamp,
             :is_read,
             :path

  has_one :user, serializer: Activity::UserSerializer
  has_one :character, serializer: Activity::CharacterSerializer

  def user
    object.sender_user
  end

  def character
    object.sender_character
  end

  def id
    object.guid
  end

  def actionable
    return unless object.actionable

    case object.actionable_type
      when 'Forum::Post'
        Activity::PostSerializer
      when 'Media::Comment'
        Activity::CommentSerializer
      when 'Media::Favorite'
        Activity::FavoriteSerializer
      else
        ActiveModel::Serializer
    end.new object.actionable, scope: scope
  end

  def timestamp
    object.created_at.to_i
  end

  def path
    "/notifications/#{object.guid}"
  end
end
