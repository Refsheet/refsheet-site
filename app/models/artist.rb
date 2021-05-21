# == Schema Information
#
# Table name: artists
#
#  id                       :integer          not null, primary key
#  guid                     :string
#  name                     :string
#  slug                     :string
#  commission_url           :string
#  website_url              :string
#  profile                  :text
#  profile_markdown         :text
#  commission_info          :text
#  commission_info_markdown :text
#  locked                   :boolean
#  media_count              :integer
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_artists_on_guid        (guid)
#  index_artists_on_lower_name  (lower((name)::text) varchar_pattern_ops)
#  index_artists_on_lower_slug  (lower((slug)::text) varchar_pattern_ops)
#  index_artists_on_user_id     (user_id)
#

class Artist < ApplicationRecord
  include HasImageAttached
  include Sluggable
  include HasGuid

  belongs_to :user, optional: true
  has_many :links, class_name: 'Artists::Link'
  has_many :artist_credits, class_name: 'Media::ArtistCredit'
  has_many :media, through: :artist_credits

  delegate :username, to: :user, allow_nil: true

  has_image_attached :avatar,
                     default_url: '/assets/default.png',
                     defaults: {
                         crop: :attention,
                     },
                     styles: {
                         thumbnail: { fill: [320, 320] },
                         small: { fit: [480, 480] },
                         medium: { fit: [640, 640] },
                     }

  has_markdown_field :commission_info
  has_markdown_field :profile
  has_guid

  slugify :name, lookups: true

  validates_presence_of :name
end
