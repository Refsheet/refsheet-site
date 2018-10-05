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

FactoryBot.define do
  factory :conversations_message, class: 'Conversations::Message' do
    conversation { "" }
    user { "" }
    message { "MyText" }
    reply_to { "" }
    read_at { "2018-10-05 13:27:15" }
    deleted_at { "2018-10-05 13:27:15" }
  end
end
