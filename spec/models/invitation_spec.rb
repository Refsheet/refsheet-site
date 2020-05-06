# == Schema Information
#
# Table name: invitations
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  email            :string
#  seen_at          :datetime
#  claimed_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auth_code_digest :string
#
# Indexes
#
#  index_invitations_on_lower_email  (lower((email)::text) varchar_pattern_ops)
#

require 'rails_helper'

describe Invitation, type: :model do
  it_is_expected_to(
    belong_to: :user,
    have_many: :transfers
  )

  describe 'auth_code' do
    let(:invitation) { create :invitation }
    let!(:auth_code) { invitation.generate_auth_code! }
    it { expect(invitation.auth_code_digest).to_not be_blank }
    it { expect(invitation.auth_code? auth_code).to eq true }
    it { expect(invitation.auth_code? 'foobar').to be false }
  end

  describe 'mailers' do
    let(:invitation) { build :invitation, :send_emails }

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
