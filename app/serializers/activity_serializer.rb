# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  guid            :string
#  user_id         :integer
#  character_id    :integer
#  activity_type   :string
#  activity_id     :integer
#  activity_method :string
#  activity_field  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_activities_on_activity_type  (activity_type)
#  index_activities_on_character_id   (character_id)
#  index_activities_on_user_id        (user_id)
#

require_dependency Rails.root.join 'app/serializers/activity/image_serializer'
require_dependency Rails.root.join 'app/serializers/activity/character_serializer'
require_dependency Rails.root.join 'app/serializers/activity/discussion_serializer'
require_dependency Rails.root.join 'app/serializers/activity/comment_serializer'
require_dependency Rails.root.join 'app/serializers/activity/user_serializer'

class ActivitySerializer < ActiveModel::Serializer
  attributes :id,
             :user,
             :character,
             :activity_type,
             :activity_method,
             :activity_field,
             :activity,
             :timestamp

  has_one :user, serializer: Activity::UserSerializer
  has_one :character, serializer: Activity::CharacterSerializer

  def id
    object.guid
  end

  def activity
    return unless object.activity

    case object.activity_type
      when 'Image'
        Activity::ImageSerializer
      when 'Character'
        Activity::CharacterSerializer
      when 'Forum::Discussion'
        Activity::DiscussionSerializer
      when 'Media::Comment'
        Activity::CommentSerializer
      else
        ActiveModel::Serializer
    end.new object.activity, scope: scope
  end

  def timestamp
    object.created_at.to_i
  end
end
