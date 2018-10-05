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
    it 'counts on user scope' do
      user1 = create :user
      user2 = create :user
      convo = described_class.with(user1, user2).tap(&:save!)
      convo.messages.create!(user: user1, message: "Hi")

      expect(described_class.for(user1).unread.count).to eq 1
      expect(described_class.for(user2).unread.count).to eq 1
      expect(described_class.for(user1).first).to be_unread
    end
  end
end
