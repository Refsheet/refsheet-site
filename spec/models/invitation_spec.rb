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

require 'rails_helper'

describe Invitation, type: :model do
  it_is_expected_to(
    belong_to: :user,
    have_many: :transfers
  )

  describe 'mailers' do
    let(:invitation) { build :invitation }

    it 'sends transfer-invite mailer' do
      expect(UserMailer).to receive(:invitation_with_transfers).and_call_original
      invitation.transfers << build(:transfer)
      invitation.save!
    end

    it 'sends transfer-invite mailer (harness for multi email test)' do
      expect(UserMailer).to receive(:invitation_with_transfers).and_call_original
      invitation.transfers << build(:transfer)
      invitation.transfers << build(:transfer)
      invitation.save!
    end

    it 'sends generic invitation' do
      expect(UserMailer).to receive(:invitation).and_call_original
      invitation.save!
    end
  end
end
