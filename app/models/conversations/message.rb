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

class Conversations::Message < ApplicationRecord
  include HasGuid

  belongs_to :conversation, required: true
  belongs_to :user, required: true
  belongs_to :reply_to, class_name: 'Conversations::Message', inverse_of: :replies

  has_many :replies,
           class_name: 'Conversations::Message',
           foreign_key: :reply_to_id,
           inverse_of: :reply_to

  validates_presence_of :message
  validate :check_blocked

  acts_as_paranoid
  has_guid

  scoped_search on: [:message]

  before_validation :handle_slash_commands
  after_create :update_bookmark
  after_create :notify_conversation

  scope :unread, -> (user=nil) {
    if user.nil?
      all
    else
      joins(<<-SQL.squish)
          INNER JOIN conversations ON conversations.id = conversations_messages.conversation_id
          LEFT OUTER JOIN conversations_read_bookmarks
            ON conversations_read_bookmarks.conversation_id = conversations.id
              AND conversations_read_bookmarks.user_id = #{user.id}
      SQL
        .where(conversations_read_bookmarks: {
            id: [Conversations::ReadBookmark.unread_for(user), nil]
        })
        .where('conversations_read_bookmarks.id IS NULL OR conversations_read_bookmarks.message_id < conversations_messages.id')
        .distinct
    end
  }

  def reply?
    self.reply_to_id.present?
  end

  def unread?(user=nil)
    return true unless user
    last_read_id = conversation.read_bookmarks.for(user)&.message_id || 0
    self.id > last_read_id
  end

  def read_at(user=nil)
    if user.nil?
      super()
    else
      last_read = conversation.read_bookmarks.for(user)

      if last_read.nil? or last_read.message_id < self.id
        nil
      else
        last_read.updated_at
      end
    end
  end

  def recipient
    self.conversation&.recipient_for(self.user)
  end

  private

  def handle_slash_commands
    if self.message[0] == '/'
      case self.message
      when "/block"
        self.user.block! self.recipient
        self.message = "<Conversation terminated.>"
      when "/unblock"
        self.user.unblock! self.recipient
        self.message = "<Conversation resumed.>"
      end
    end
  end

  def notify_conversation
    self.conversation.notify_message(self)
  end

  def update_bookmark
    self.conversation.read_by! self.user
  end

  def check_blocked
    if recipient&.blocked? self.user
      errors.add(:conversation, "cannot receive messages right now")
    end
  end
end
