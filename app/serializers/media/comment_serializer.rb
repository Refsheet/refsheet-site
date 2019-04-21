# == Schema Information
#
# Table name: media_comments
#
#  id                  :integer          not null, primary key
#  media_id            :integer
#  user_id             :integer
#  reply_to_comment_id :integer
#  comment             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_media_comments_on_guid                 (guid)
#  index_media_comments_on_media_id             (media_id)
#  index_media_comments_on_reply_to_comment_id  (reply_to_comment_id)
#  index_media_comments_on_user_id              (user_id)
#

class Media::CommentSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :media_id,
             :user_id,
             :comment,
             :reply_to_comment_id,
             :created_at,
             :created_at_human

  has_one :user, serializer: UserIndexSerializer
  has_many :replies, serializer: Media::CommentSerializer

  def id
    object.guid
  end

  def media_id
    object.media.guid
  end

  def user_id
    object.user.username
  end

  def reply_to_comment_id
    object.reply_to&.guid
  end

  def created_at_human
    t = time_ago_in_words(object.created_at).split(' ')
    return '<1 m' if t[0] =~ /\Aless/
    t.shift if t[0] =~ /\Aabout/
    t[1] = t[1][0]
    t.join(' ')
  end
end
