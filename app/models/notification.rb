# == Schema Information
#
# Table name: notifications
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  character_id        :integer
#  sender_user_id      :integer
#  sender_character_id :integer
#  type                :string
#  actionable_id       :integer
#  actionable_type     :string
#  read_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_notifications_on_character_id  (character_id)
#  index_notifications_on_guid          (guid)
#  index_notifications_on_type          (type)
#  index_notifications_on_user_id       (user_id)
#

class Notification < ApplicationRecord
  include HasGuid
  include Rails.application.routes.url_helpers

  MEDIUMS = {
      web_push: "Browser Push",
      email: "Email"
  }

  belongs_to :user
  belongs_to :character
  belongs_to :sender_user, class_name: "User"
  belongs_to :sender_character, class_name: "Character"
  belongs_to :actionable, polymorphic: :true

  validates_presence_of :user
  validates_presence_of :sender_user
  validates_presence_of :actionable

  scope :unread, -> { where read_at: nil }

  scope :eager_loaded, -> {
    includes(
        :user,
        :actionable,
        :sender_user,
        character: [:user, :profile_image, :featured_image],
        sender_character: [:user, :profile_image, :featured_image],
        # activity_image: [:character, :favorites],
        # activity_comment: [:media],
        # activity_discussion: [:forum],
        # activity_character: [:user, :profile_image, :featured_image]
    )
  }

  scope :default_sort, -> { order created_at: :desc }
  scope :for, -> (user) { where user: user }

  after_create :send_browser_push
  after_create :send_email

  has_guid


  #== Class Things

  def self.notify!(user, sender_user, actionable)
    self.create user: user,
                sender_user: sender_user,
                actionable: actionable
  end


  #== Global State Things

  def read!
    self.read_at = Time.zone.now
    self.save!
  end

  def unread!
    self.read_at = nil
    self.save!
  end

  def unread?
    self.read_at.nil?
  end

  def read?
    !unread?
  end

  def sender
    sender_character || sender_user
  end

  def recipient
    character || user
  end


  #== Notification Context Items
  #   (these can and should be overridden for each type)

  def title
    "New notification!"
  end

  def message
    nil
  end

  def icon
    sender&.avatar_url
  end

  def href
    nil
  end

  def link
    nil
  end

  def tag
    if actionable&.respond_to? :guid
      "#{permission_key}-#{actionable&.guid}"
    else
      "#{permission_key}-#{self.guid}"
    end
  end

  # Send GraphQL broadcast
  def broadcast!
    trigger! "newNotification",
             {},
             self,
             scope: user.id
  end


  protected

  def permission_key
    self.type
  end


  private

  def user_allows?(medium)
    permissions = user.settings(:notifications)[medium] || {}

    if permissions.include? permission_key
      permissions[permission_key]
    else
      new_perms = permissions.merge permission_key => true
      user.settings(:notifications).update_attributes medium: new_perms
      true
    end
  end

  def send_browser_push
    return unless user_allows? :browser_push

    user.notify! title, message,
                 image: icon,
                 href: href,
                 tag: tag
  end

  def send_email
    return unless user_allows? :email
    # UserMailer.notification(self).deliver_now
  end
end
