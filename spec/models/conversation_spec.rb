# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  approved     :boolean
#  subject      :string
#  muted        :boolean
#  guid         :string
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_conversations_on_guid          (guid)
#  index_conversations_on_recipient_id  (recipient_id)
#  index_conversations_on_sender_id     (sender_id)
#

require 'rails_helper'

describe Conversation, type: :model do
  it_is_expected_to(
    belong_to: [
        :sender,
        :recipient
    ],
    have_many: [
        :messages
    ],
    validate_presence_of: [
        [:sender, with_message: :required],
        [:recipient, with_message: :required]
    ]
  )

  describe '#with' do
    it 'initializes conversation' do
      user1 = create :user
      user2 = create :user

      convo = described_class.with(user1, user2).tap(&:save!)
      convo.messages.create!(user: user1, message: "Hi")

      expect(convo).to be_persisted
      expect(convo).to be_unread
    end

    it 'pulls old conversation' do
      user1 = create :user
      user2 = create :user
      old = described_class.with(user1, user2).tap(&:save!)
      convo = described_class.with(user2, user1)
      expect(convo).to eq old
    end
  end

  describe '.unread' do
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:convo) { described_class.with(user1, user2).tap(&:save!) }

    let!(:message) { convo.messages.create!(user: user1, message: "Hi") }

    describe 'automatically reads sender' do
      it { expect(described_class.for(user1).unread(user1).count).to eq 0 }
      it { expect(described_class.for(user1).first.unread?(user1)).to be_falsey }
      it { expect(message.unread?(user1)).to be_falsey }
    end


    describe 'shows unread for recipient' do
      it { expect(described_class.for(user2).unread(user2).count).to eq 1 }
      it { expect(described_class.for(user2).first.unread?(user2)).to be_truthy }
      it { expect(message.unread?(user2)).to be_truthy }
    end

    describe 'shows unread with message after bookmark' do
      let!(:msg) do
        convo.read_by! user2
        convo.messages.create!(user: user1, message: "Hey")
      end

      it { expect(described_class.for(user2).unread(user2).count).to eq 1 }
      it { expect(msg.unread?(user1)).to be_falsey }
      it { expect(msg.unread?(user2)).to be_truthy }
      it('uc2') { expect(convo.unread_count(user2)).to eq 1 }
    end

    describe 'marks read' do
      before do
        convo.read_by! user1
        convo.read_by! user2
      end

      it { expect(described_class.for(user2).unread(user2).count).to eq 0 }
      it { expect(described_class.for(user2).first.unread?(user2)).to be_falsey }
      it { expect(convo.unread_count(user2)).to eq 0 }
    end
  end
end
