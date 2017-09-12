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

FactoryGirl.define do
  factory :forum_discussion, class: 'Forum::Discussion' do
    forum
    user
    topic { Faker::LordOfTheRings.location }
    content { Faker::Lorem.paragraph(2) }
  end
end
