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

FactoryBot.define do
  factory :artist do
    name { Faker::Ancient.god }
    commission_url { Faker::Internet.url }
    website_url { Faker::Internet.url }
    profile { Faker::Movies::PrincessBride.quote }
    commission_info { Faker::Movies::HitchhikersGuideToTheGalaxy.marvin_quote }

    trait :with_user do
      user
    end
  end
end
