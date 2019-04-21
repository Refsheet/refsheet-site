# == Schema Information
#
# Table name: notifications
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  character_id        :integer
#  sender_user_id      :integer
#  sender_character_id :integer
#  type                :string
#  actionable_id       :integer
#  actionable_type     :string
#  read_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_notifications_on_character_id  (character_id)
#  index_notifications_on_guid          (guid)
#  index_notifications_on_type          (type)
#  index_notifications_on_user_id       (user_id)
#

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
