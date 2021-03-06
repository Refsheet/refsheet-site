# == Schema Information
#
# Table name: activities
#
#  id                   :integer          not null, primary key
#  guid                 :string
#  user_id              :integer
#  character_id         :integer
#  activity_type        :string
#  activity_id          :integer
#  activity_method      :string
#  activity_field       :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  comment              :text
#  reply_to_activity_id :integer
#
# Indexes
#
#  index_activities_on_activity_type         (activity_type)
#  index_activities_on_character_id          (character_id)
#  index_activities_on_reply_to_activity_id  (reply_to_activity_id)
#  index_activities_on_user_id               (user_id)
#

FactoryBot.define do
  factory :activity do
    guid { "MyString" }
    user_id { 1 }
    character_id { 1 }
    activity_type { "MyString" }
    activity_id { 1 }
    activity_method { "MyString" }
    activity_field { "MyString" }
  end
end
