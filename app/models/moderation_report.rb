# == Schema Information
#
# Table name: moderation_reports
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  sender_user_id   :integer
#  moderatable_id   :integer
#  moderatable_type :string
#  violation_type   :string
#  comment          :text
#  dmca_source_url  :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_moderation_reports_on_moderatable_id    (moderatable_id)
#  index_moderation_reports_on_moderatable_type  (moderatable_type)
#  index_moderation_reports_on_sender_user_id    (sender_user_id)
#  index_moderation_reports_on_status            (status)
#  index_moderation_reports_on_user_id           (user_id)
#  index_moderation_reports_on_violation_type    (violation_type)
#

class ModerationReport < ApplicationRecord
  VIOLATION_TYPES = {
      dmca: "User doesn't have permission to post this.",
      improper_flag: "This item was not flagged for proper maturity level.",
      offensive: "This item is offensive or violates community standards.",
      other: "Other, please specify in comment."
  }.with_indifferent_access.freeze

  belongs_to :user
  belongs_to :sender, foreign_key: :sender_user_id, class_name: "User"
  belongs_to :moderatable, polymorphic: true

  validates_presence_of :violation_type
  validates_inclusion_of :violation_type, in: VIOLATION_TYPES.keys
  validates_presence_of :moderatable

  validates_presence_of :comment, if: -> (r) { r.violation_type == 'other' }

  after_create :send_moderator_email

  before_validation :assign_user

  VIOLATION_TYPES.keys.each do |key|
    scope key, -> { where violation_type: key }
  end

  state_machine :status, initial: :pending do
    before_transition any => :removed, do: [:auto_remove_item, :send_removal_notice]
    before_transition any => :reflagged, do: [:auto_reflag_item, :send_reflag_notice]
    before_transition any => :complete, do: [:send_generic_notice]

    state :assigned
    state :dismissed
    state :removed
    state :reflagged
    state :complete

    event :dismiss do
      transition [:pending, :assigned] => :dismissed
    end

    # Remove the image and issue a moderation notice
    # to the poster.
    #
    event :remove do
      transition [:pending, :assigned] => :removed
    end

    # Automatically reflag the image as NSFW.
    #
    event :reflag do
      transition [:pending, :assigned] => :reflagged
    end

    # Assume manual action was taken on the image.
    #
    event :complete do
      transition [:pending, :assigned] => :complete
    end

    # Lazy mods are lazy
    #
    event :auto_resolve do
      transition [:pending, :assigned] => :removed, if: -> (r) { r.violation_type.in? %w(dmca offensive) }
      transition [:pending, :assigned] => :reflagged, if: -> (r) { r.violation_type == 'improper_flag' }
      transition [:pending, :assigned] => :complete
    end
  end

  scope :pending, -> { where status: :pending }

  def self.next
    pending.order(created_at: :asc).first
  end


  def violation_message
    VIOLATION_TYPES[violation_type]
  end

  private

  def assign_user
    if moderatable.is_a? Image
      self.user = moderatable.character.user
    end
  end

  def send_moderator_email
    User.with_role(Role::MODERATOR).each do |mod|
      ModeratorMailer.new_report(self, mod).deliver_now
    end
  end

  def send_removal_notice
    ModeratorMailer.item_removed(self).deliver_now if user
  end

  def send_reflag_notice
    ModeratorMailer.item_reflagged(self).deliver_now if user
  end

  def send_generic_notice
    ModeratorMailer.item_moderated(self).deliver_now if user
  end

  def auto_remove_item
    case moderatable_type
      when 'Image'
        moderatable.destroy
    end
  end

  def auto_reflag_item
    case moderatable_type
      when 'Image'
        moderatable.update_columns nsfw: true
    end
  end
end
