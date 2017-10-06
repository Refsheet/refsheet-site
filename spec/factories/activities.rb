# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  guid            :string
#  user_id         :integer
#  character_id    :integer
#  activity_type   :string
#  activity_id     :integer
#  activity_method :string
#  activity_field  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :activity do
    guid "MyString"
    user_id 1
    character_id 1
    activity_type "MyString"
    activity_id 1
    activity_method "MyString"
    activity_field "MyString"
  end
end
