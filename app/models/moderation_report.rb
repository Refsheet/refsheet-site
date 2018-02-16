# == Schema Information
#
# Table name: moderation_reports
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  sender_user_id   :integer
#  moderatable_id   :integer
#  moderatable_type :string
#
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
  belongs_to :sender, foreign_key: :sender_user_id, class_name: User
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
    state :assigned
    state :dismissed
    state :removed
    state :complete
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
      # ModeratorMailer.new_report(self, mod).deliver_now
    end
  end

  def send_removed_email
    # ModeratorMailer.item_removed(self).deliver_now if user
  end
end
