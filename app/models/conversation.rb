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

  # belongs_to :sender_character, class_name: 'Character', required: -> { self.character_conversation? }
  # belongs_to :recipient_character, class_name: 'Character', required: -> { self.character_conversation? }

  has_many :messages, dependent: :destroy, class_name: 'Conversations::Message'
  has_many :read_bookmarks, dependent: :destroy, class_name: 'Conversations::ReadBookmark'

  validates_uniqueness_of :sender_id, scope: :recipient_id, unless: -> { self.character_conversation? }
  # validates_uniqueness_of :sender_character_id, scope: :recipient_character_id, if: -> { self.character_conversation? }

  acts_as_paranoid
  has_guid

  scoped_search on: [:subject]
  scoped_search relation: :recipient, on: [:username, :name]
  scoped_search relation: :messages, on: [:message]

  scope :for, -> (user_or_character) do
    if user_or_character.is_a? User
      where(<<-SQL.squish, user_or_character.id, user_or_character.id)
        conversations.sender_id = ? OR conversations.recipient_id = ?
      SQL
      # AND conversatoins.character_conversation = FALSE
    else
      where(<<-SQL.squish, user_or_character.id, user_or_character.id)
        conversations.sender_character_id = ? OR conversations.recipient_character_id = ?
      SQL
      # AND conversatoins.character_conversation = TRUE
    end
  end

  scope :between, -> (sender, recipient) do
    where(<<-SQL.squish, sender.id, recipient.id, sender.id, recipient.id)
      (conversations.sender_id = ? AND conversations.recipient_id = ?) OR
      (conversations.recipient_id = ? AND conversations.sender_id = ?)
    SQL
  end

  scope :unread, -> (for_user=nil) do
    if for_user.nil?
      all
    else
      joins(:messages)
        .joins(<<-SQL.squish)
            LEFT OUTER JOIN conversations_read_bookmarks
              ON conversations_read_bookmarks.conversation_id = conversations.id
                AND conversations_read_bookmarks.user_id = #{for_user.id}
        SQL
        .where(conversations_read_bookmarks: {
            id: [Conversations::ReadBookmark.unread_for(for_user), nil]
        })
        .distinct
    end
  end

  def self.with(sender, recipient)
    self.between(sender, recipient).first or
        self.new(sender: sender, recipient: recipient)
  end

  def self.counts_for(user)
    {
        unread: self.for(user).unread(user).count
    }
  end

  def character_conversation?
    false
  end

  def participants
    [self.sender, self.recipient]
  end

  def recipient_for(user)
    (participants - [user]).first
  end

  def participant_ids
    [self.sender_id, self.recipient_id]
  end

  def unread_count(user=nil)
    self.messages.unread(user).count
  end

  def last_message
    messages.order(created_at: :asc).last
  end

  def unread?(user=nil)
    self.messages.unread(user).exists?
  end

  def read_by!(user)
    self.read_bookmarks.for(user).update_attributes(message: self.messages.last)

    trigger! "chatCountsChanged",
             {},
             self.class.counts_for(user),
             scope: user.id
  end

  def notify_message(message)
    notify_users = self.participant_ids

    notify_users.each do |user_id|
      trigger! "newMessage",
               { conversationId: self.guid },
               message,
               scope: user_id

      trigger! "convChanged",
               { convId: self.guid },
               self,
               scope: user_id

      if user_id != message.user_id
        trigger! "chatCountsChanged",
                 {},
                 self.class.counts_for(User.find_by(id: user_id)),
                 scope: user_id
      end
    end
  end
end
