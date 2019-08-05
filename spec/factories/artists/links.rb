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
#  index_artists_links_on_submitted_by_id  (submitted_by_id)
#

FactoryBot.define do
  factory :artists_link, class: 'Artists::Link' do
    guid { "MyString" }
    artist { nil }
    url { "MyString" }
    submitted_by { "" }
    approved_by { "" }
    approved_at { "2019-08-05 15:17:08" }
    favicon_url { "MyString" }
  end
end
