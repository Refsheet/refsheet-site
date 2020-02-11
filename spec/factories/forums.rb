# == Schema Information
#
# Table name: forums
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  slug            :string
#  locked          :boolean
#  nsfw            :boolean
#  no_rp           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  system_owned    :boolean          default(FALSE)
#  rules           :text
#  prepost_message :text
#  owner_id        :integer
#  fandom_id       :integer
#  open            :boolean          default(FALSE)
#
# Indexes
#
#  index_forums_on_fandom_id     (fandom_id)
#  index_forums_on_owner_id      (owner_id)
#  index_forums_on_slug          (slug)
#  index_forums_on_system_owned  (system_owned)
#

FactoryBot.define do
  factory :forum do
    name { Faker::Movies::LordOfTheRings.location }
    description { Faker::Lorem.paragraph }
    sequence(:slug) { |i| "forum-#{i}"}
  end
end
