# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  email      :string
#  seen_at    :datetime
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :invitation do
    user_id 1
    email "MyString"
    seen_at "2017-01-30 17:19:45"
    claimed_at "2017-01-30 17:19:45"
  end
end
