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

class Conversation < ApplicationRecord
  include HasGuid

  belongs_to :sender, class_name: 'User', required: true
  belongs_to :recipient, class_name: 'User', required: true

  has_many :messages, dependent: :destroy, class_name: 'Conversations::Message'

  validates_uniqueness_of :sender_id, scope: :recipient_id

  acts_as_paranoid
  has_guid

  scoped_search on: [:subject]
  scoped_search relation: :recipient, on: [:username, :name]
  scoped_search relation: :messages, on: [:message]

  scope :for, -> (user) do
    where(<<-SQL.squish, user.id, user.id)
      conversations.sender_id = ? OR conversations.recipient_id = ?
    SQL
  end

  scope :between, -> (sender, recipient) do
    where(<<-SQL.squish, sender.id, recipient.id, sender.id, recipient.id)
      (conversations.sender_id = ? AND conversations.recipient_id = ?) OR
      (conversations.recipient_id = ? AND conversations.sender_id = ?)
    SQL
  end

  scope :unread, -> do
    joins(:messages).where(conversations_messages: { read_at: nil })
  end

  def self.with(sender, recipient)
    self.between(sender, recipient).first or
        self.new(sender: sender, recipient: recipient)
  end

  def participants
    [self.sender, self.recipient]
  end

  def participant_ids
    [self.sender_id, self.recipient_id]
  end

  def unread?
    self.messages.unread.any?
  end

  def notify_message(message)
    notify_users = self.participant_ids #.reject { |p| p == message.user_id }

    notify_users.each do |user_id|
      RefsheetSchema.subscriptions.trigger("newMessage", {}, message)
    end
  end
end
