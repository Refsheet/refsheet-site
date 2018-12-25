# == Schema Information
#
# Table name: user_sessions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  ahoy_visit_id        :integer
#  session_guid         :string
#  session_token_digest :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_ahoy_visit_id  (ahoy_visit_id)
#  index_user_sessions_on_session_guid   (session_guid)
#  index_user_sessions_on_user_id        (user_id)
#

require 'rails_helper'

describe UserSession, type: :model do
  it_is_expected_to(
    respond_to: [:session_token],
    belong_to: [:user, :ahoy_visit]
  )

  describe '#session_token' do
    let(:session) { create :user_session }

    it 'is visible on create' do
      expect(session.session_token).to_not be_nil
      expect(session.session_token).to match /^[a-f0-9]{32}$/
      reloaded = UserSession.find(session.id)
      expect(reloaded.session_token).to be_nil
      expect(reloaded.session_token_digest).to_not be_nil
    end

    it 'authenticates' do
      token = session.session_token
      session.reload
      expect(session.authenticate(token)).to be_truthy
    end

    it 'authenticates false' do
      session.reload
      expect(session.authenticate("nachos")).to be_falsey
    end
  end
end
