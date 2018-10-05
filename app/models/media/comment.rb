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

class Media::Comment < ApplicationRecord
  include NamespacedModel
  include HasGuid
  include Rails.application.routes.url_helpers

  belongs_to :media, class_name: "Image", counter_cache: :comments_count, inverse_of: :comments
  belongs_to :user
  belongs_to :reply_to, class_name: "Media::Comment", foreign_key: :reply_to_comment_id
  has_many :replies, class_name: "Media::Comment", foreign_key: :reply_to_comment_id

  # Requires this to eager load the news feed:
  has_many :activities, as: :activity, dependent: :destroy

  validates_presence_of :media
  validates_presence_of :user
  validates_presence_of :comment

  after_create :log_activity
  after_create :notify_user

  has_guid

  def media_type
    'Image'
  end

  private

  def log_activity
    Activity.create activity: self, user_id: self.user_id, created_at: self.created_at, activity_method: 'create'
  end

  def notify_user
    Notifications::ImageComment.notify! media.user, user, self
  end
end
