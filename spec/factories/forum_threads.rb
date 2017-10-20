# == Schema Information
#
# Table name: forum_threads
#
#  id           :integer          not null, primary key
#  forum_id     :integer
#  user_id      :integer
#  character_id :integer
#  topic        :string
#  slug         :string
#  shortcode    :string
#  content      :text
#  locked       :boolean
#  karma_total  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_forum_threads_on_character_id  (character_id)
#  index_forum_threads_on_forum_id      (forum_id)
#  index_forum_threads_on_karma_total   (karma_total)
#  index_forum_threads_on_shortcode     (shortcode)
#  index_forum_threads_on_slug          (slug)
#  index_forum_threads_on_user_id       (user_id)
#

FactoryGirl.define do
  factory :forum_discussion, class: 'Forum::Discussion' do
    forum
    user
    topic { Faker::LordOfTheRings.location }
    content { Faker::Lorem.paragraph(2) }
  end
end
