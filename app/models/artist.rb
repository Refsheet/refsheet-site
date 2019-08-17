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
#  index_artists_on_guid     (guid)
#  index_artists_on_slug     (slug)
#  index_artists_on_user_id  (user_id)
#

class Artist < ApplicationRecord
  include Sluggable
  include HasGuid

  belongs_to :user, optional: true

  delegate :username, to: :user, allow_nil: true

  has_one_attached :avatar
  has_markdown_field :commission_info
  has_markdown_field :profile
  has_guid

  slugify :name, lookups: true

  validates_presence_of :name
end
