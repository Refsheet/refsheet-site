# == Schema Information
#
# Table name: artists_links
#
#  id              :integer          not null, primary key
#  guid            :string
#  artist_id       :integer
#  url             :string
#  submitted_by_id :integer
#  approved_by_id  :integer
#  approved_at     :datetime
#  favicon_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_artists_links_on_approved_by_id   (approved_by_id)
#  index_artists_links_on_artist_id        (artist_id)
#  index_artists_links_on_guid             (guid)
#  index_artists_links_on_submitted_by_id  (submitted_by_id)
#

class Artists::Link < ApplicationRecord
  belongs_to :artist
  belongs_to :approved_by, class_name: 'User'
  belongs_to :submitted_by, class_name: 'User'
end
