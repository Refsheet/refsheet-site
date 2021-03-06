# == Schema Information
#
# Table name: conversations_read_bookmarks
#
#  id              :integer          not null, primary key
#  conversation_id :integer
#  message_id      :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_conversations_read_bookmarks_on_conversation_id  (conversation_id)
#  index_conversations_read_bookmarks_on_message_id       (message_id)
#  index_conversations_read_bookmarks_on_user_id          (user_id)
#

require 'rails_helper'

describe Conversations::ReadBookmark, type: :model do
  it_is_expected_to(
      belong_to: [
          :conversation, :message, :user
      ]
  )
end
