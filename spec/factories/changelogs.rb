# == Schema Information
#
# Table name: changelogs
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  changed_character_id :integer
#  changed_user_id      :integer
#  changed_image_id     :integer
#  changed_swatch_id    :integer
#  reason               :text
#  change_data          :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :changelog do
    user_id 1
    changed_character_id 1
    changed_user_id 1
    changed_image_id 1
    changed_swatch_id 1
    reason "MyText"
    changes ""
  end
end
