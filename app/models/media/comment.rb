class Media::Comment < ApplicationRecord
  include NamespacedModel

  belongs_to :media, class_name: Image
  belongs_to :user
  has_many :replies, class_name: Media::Comment, foreign_key: :reply_to_comment_id

  validates_presence_of :media
  validates_presence_of :user
  validates_presence_of :comment
end
