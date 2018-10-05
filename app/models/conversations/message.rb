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

  acts_as_paranoid
  has_guid

  scoped_search on: [:message]

  after_create :notify_conversation

  scope :unread, -> { where read_at: nil }

  def reply?
    self.reply_to_id.present?
  end

  def unread?
    self.read_at.nil?
  end

  private

  def notify_conversation
    self.conversation.notify_message(self)
  end
end
