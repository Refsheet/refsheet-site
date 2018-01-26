# == Schema Information
#
# Table name: notifications
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  character_id        :integer
#  sender_user_id      :integer
#  sender_character_id :integer
#  type                :string
#  actionable_id       :integer
#  actionable_type     :string
#  read_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_notifications_on_character_id  (character_id)
#  index_notifications_on_type          (type)
#  index_notifications_on_user_id       (user_id)
#

FactoryGirl.define do
  factory :notification do
    user_id 1
    character_id 1
    sender_user_id 1
    sender_character_id 1
    type ""
    actionable_id 1
    actionable_type "MyString"
    read_at "2018-01-25 19:23:28"
  end
end
