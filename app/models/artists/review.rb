# == Schema Information
#
# Table name: artists_reviews
#
#  id         :integer          not null, primary key
#  guid       :string
#  artist_id  :integer
#  user_id    :integer
#  rating     :integer
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_artists_reviews_on_artist_id  (artist_id)
#  index_artists_reviews_on_guid       (guid)
#  index_artists_reviews_on_user_id    (user_id)
#

class Artists::Review < ApplicationRecord
  belongs_to :artist
  belongs_to :user
end
