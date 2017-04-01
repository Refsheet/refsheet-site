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

require 'rails_helper'

describe Transfer, type: :model do
  it_is_expected_to(
    belong_to: [
      :character,
      :item,
      :sender,
      :destination,
      :invitation
    ],
    validate_presence_of: [
      :sender,
      :destination,
      :invitation,
      :character
    ]
  )

  context 'when rejected' do
    let(:transfer) { build :transfer, status: :rejected }
    subject { transfer }
    it_is_expected_to validate_presence_of: :rejected_at
  end

  context 'when claimed' do
    let(:transfer) { build :transfer, status: :claimed }
    subject { transfer }
    it_is_expected_to validate_presence_of: :claimed_at
  end
end
