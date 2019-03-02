# == Schema Information
#
# Table name: conversations_messages
#
#  id              :integer          not null, primary key
#  conversation_id :integer
#  user_id         :integer
#  message         :text
#  reply_to_id     :integer
#  read_at         :datetime
#  deleted_at      :datetime
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_conversations_messages_on_conversation_id  (conversation_id)
#  index_conversations_messages_on_guid             (guid)
#  index_conversations_messages_on_reply_to_id      (reply_to_id)
#  index_conversations_messages_on_user_id          (user_id)
#

require 'rails_helper'

describe Conversations::Message, type: :model do
  it_is_expected_to(
    belong_to: [
        :conversation,
        :user,
        :reply_to
    ],
    have_many: [
        :replies
    ],
    validate_presence_of: [
        [:conversation, with_message: :required],
        [:user, with_message: :required],
        :message
    ]
  )

  it 'notifies graphql sub' do
    allow(RefsheetSchema.subscriptions)
        .to receive(:trigger)

    create :conversations_message

    expected_pubs = %w[newMessage convChanged chatCountsChanged]

    expected_pubs.each do |pub|
      expect(RefsheetSchema.subscriptions)
          .to have_received(:trigger)
          .with(pub, any_args)
          .at_least(:once)
    end
  end

  it 'fails to send to blocked user' do
    msg = create :conversations_message
    con = msg.conversation
    u1 = con.sender
    u2 = con.recipient

    u2.follow! u1
    expect(u1).to be_followed_by u2
    u1.block! u2
    expect(u1).to_not be_followed_by u2

    message = con.messages.create(user: u2, message: "OwO")
    expect(message).to_not be_valid
    expect(message).to have(1).errors_on(:conversation)
  end
end
