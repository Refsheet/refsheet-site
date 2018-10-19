# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_forums_on_slug  (slug)
#

FactoryBot.define do
  factory :forum do
    name { Faker::LordOfTheRings.location }
    description { Faker::Lorem.paragraph }
    sequence(:slug) { |i| "forum-#{i}"}
  end
end
