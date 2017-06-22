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
    character
    sender { character.user }
    destination { build :user }

    trait :with_invitation do
      destination nil
      invitation { build :invitation }
    end
  end
end
