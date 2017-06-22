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

class Media::Comment < ApplicationRecord
  include NamespacedModel
  include HasGuid

  belongs_to :media, class_name: Image
  belongs_to :user
  belongs_to :reply_to, class_name: Media::Comment, foreign_key: :reply_to_comment_id
  has_many :replies, class_name: Media::Comment, foreign_key: :reply_to_comment_id

  validates_presence_of :media
  validates_presence_of :user
  validates_presence_of :comment

  has_guid
end
