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

  scope :eager_loaded, -> {
    includes(
        :user,
        :character,
        :activity,
        :activity_image,
        activity_comment: [:media],
        activity_discussion: [:forum],
        activity_character: [:user, :profile_image, :featured_image]
    )
  }
end
