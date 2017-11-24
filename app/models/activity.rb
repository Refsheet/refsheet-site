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

class Activity < ApplicationRecord
  include HasGuid

  belongs_to :user
  belongs_to :character
  belongs_to :activity, polymorphic: true

  # Active Record needs this to eager load all the things...
  belongs_to :activity_image, ->{ joins(:activities).where(activities: { id: Activity.where(activity_type: 'Image') }) }, class_name: 'Image', foreign_key: :activity_id
  belongs_to :activity_comment, ->{ joins(:activities).where(activities: { id: Activity.where(activity_type: 'Media::Comment') }) }, class_name: 'Media::Comment', foreign_key: :activity_id
  belongs_to :activity_discussion, ->{ joins(:activities).where(activities: { id: Activity.where(activity_type: 'Forum::Discussion') }) }, class_name: 'Forum::Discussion', foreign_key: :activity_id
  belongs_to :activity_character, ->{ joins(:activities).where(activities: { id: Activity.where(activity_type: 'Character') }) }, class_name: 'Character', foreign_key: :activity_id

  has_guid

  validates_presence_of :user
  validates_presence_of :activity
  validates_presence_of :activity_method
  validates_inclusion_of :activity_method, in: %w(create update)

  scope :feed_for, -> (user) { where(user: user).or where user: user.followed_users }

  scope :eager_loaded, -> {
    includes(
        :user,
        :activity,
        character: [:user, :profile_image, :featured_image],
        activity_image: [:character, :favorites],
        activity_comment: [:media],
        activity_discussion: [:forum],
        activity_character: [:user, :profile_image, :featured_image]
    )
  }
end
