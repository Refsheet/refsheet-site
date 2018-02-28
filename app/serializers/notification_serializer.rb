require_dependency Rails.root.join 'app/serializers/activity/image_serializer'
require_dependency Rails.root.join 'app/serializers/activity/character_serializer'
require_dependency Rails.root.join 'app/serializers/activity/discussion_serializer'
require_dependency Rails.root.join 'app/serializers/activity/comment_serializer'
require_dependency Rails.root.join 'app/serializers/activity/user_serializer'

class NotificationSerializer < ActiveModel::Serializer
  attributes :id,
             :type,
             :title,
             :message,
             :href,
             :tag,
             :user,
             :character,
             :actionable_type,
             :actionable,
             :timestamp

  has_one :user, serializer: Activity::UserSerializer
  has_one :character, serializer: Activity::CharacterSerializer

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
      # when 'Media::Favorite'
      #   Activity::FavoriteSerializer
      else
        ActiveModel::Serializer
    end.new object.actionable, scope: scope
  end

  def timestamp
    object.created_at.to_i
  end
end
