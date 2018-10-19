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

class Conversations::ReadBookmark < ApplicationRecord
  belongs_to :conversation, optional: false
  belongs_to :message, optional: false, class_name: 'Conversations::Message'
  belongs_to :user, optional: false

  scope :unread_for, -> (user) {
    where(user: user)
      .joins(<<-SQL.squish)
          INNER JOIN conversations
            ON conversations.id = conversations_read_bookmarks.conversation_id
          INNER JOIN conversations_messages
            ON conversations_messages.conversation_id = conversations.id
      SQL
      .where('conversations_messages.id > conversations_read_bookmarks.message_id')
      .distinct
  }

  def self.for(user)
    all.where(user: user).first_or_initialize
  end
end
