# == Schema Information
#
# Table name: transfers
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  item_id             :integer
#  sender_user_id      :integer
#  destination_user_id :integer
#  invitation_id       :integer
#  seen_at             :datetime
#  claimed_at          :datetime
#  rejected_at         :datetime
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#

FactoryGirl.define do
  factory :transfer do
    character_id 1
    item_id 1
    sender_user_id 1
    destination_user_id 1
    invitation_id 1
    seen_at "2017-01-30 17:18:58"
    claimed_at "2017-01-30 17:18:58"
    rejected_at "2017-01-30 17:18:58"
    status "MyString"
  end
end
