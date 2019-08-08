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

FactoryBot.define do
  factory :artists_review, class: 'Artists::Review' do
    guid { "MyString" }
    artist { nil }
    user { nil }
    rating { 1 }
    comment { "MyText" }
  end
end
