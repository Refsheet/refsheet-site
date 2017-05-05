class Media::CommentSerializer < ActiveModel::Serializer
  attributes :media_id,
             :user_id,
             :comment,
             :reply_to_comment_id,
             :created_at

  has_many :replies, serializer: Media::CommentSerializer

  def media_id
    object.media.guid
  end

  def user_id
    object.user.username
  end

  def reply_to_comment_id
    object.reply_to.guid
  end
end
