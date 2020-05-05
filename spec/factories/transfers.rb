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
# Indexes
#
#  index_transfers_on_character_id         (character_id)
#  index_transfers_on_destination_user_id  (destination_user_id)
#  index_transfers_on_guid                 (guid)
#  index_transfers_on_item_id              (item_id)
#  index_transfers_on_sender_user_id       (sender_user_id)
#  index_transfers_on_status               (status)
#

FactoryBot.define do
  factory :transfer do
    character
    sender { character.user }
    destination { build :user }

    trait :with_invitation do
      destination { nil }
      invitation { build :invitation }
    end
  end
end
