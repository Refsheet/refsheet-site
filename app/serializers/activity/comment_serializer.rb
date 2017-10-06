require_dependency Rails.root.join 'app/serializers/activity/image_serializer'

class Activity::CommentSerializer < ActiveModel::Serializer
  attributes :id,
             :media_type,
             :media,
             :comment

  def id
    object.guid
  end

  def media
    return unless object.media

    case object.media_type
      when 'Image'
        Activity::ImageSerializer
      else
        ActiveModel::Serializer
    end.new object.media, scope: scope
  end
end
