# == Schema Information
#
# Table name: transfers
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  item_id             :integer
#  sender_user_id      :integer
#  destination_user_id :integer
#  invitation_id       :integer
#  seen_at             :datetime
#  claimed_at          :datetime
#  rejected_at         :datetime
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_transfers_on_guid  (guid)
#

class Transfer < ApplicationRecord
  include HasGuid

  belongs_to :character, -> { with_deleted }
  belongs_to :item
  belongs_to :sender, class_name: User, foreign_key: :sender_user_id
  belongs_to :destination, class_name: User, foreign_key: :destination_user_id
  belongs_to :invitation

  scope :pending, -> { where status: :pending }

  validates_presence_of :sender
  validates_presence_of :destination, unless: -> (t) { t.invitation.present? }
  validates_presence_of :invitation, unless: -> (t) { t.destination.present? }
  validates_presence_of :character
  validates_inclusion_of :status, in: %w(pending rejected claimed)

  before_validation :assign_sender
  after_create :notify_recipient

  has_guid :guid

  state_machine :status, initial: :pending do
    before_transition :pending => :rejected, do: :reject_transfer
    before_transition :pending => :claimed, do: :claim_transfer

    state :rejected do
      validates_presence_of :rejected_at
    end

    state :claimed do
      validates_presence_of :claimed_at
    end

    # state :canceled

    event :claim do
      transition :pending => :claimed, if: :claimable?
      transition :pending => same
    end

    event :reject do
      transition :pending => :rejected, unless: :sold?
      transition :pending => same
    end

    # event :cancel do
    #   transition :pending => :canceled
    # end
  end

  def claimable?
    self.destination.present?
  end

  def sold?
    self.item.present?
  end

  private

  def assign_sender
    self.sender ||= self.character&.user
  end

  def notify_recipient
    if self.invitation.nil? and self.item.nil?
      TransferMailer.incoming(id).deliver_now
    end
  end

  def claim_transfer
    self.character.update_attributes user: self.destination
    self.claimed_at = DateTime.now
    TransferMailer.accepted(id).deliver_now
  end

  def reject_transfer
    self.rejected_at = DateTime.now
    TransferMailer.rejected(id).deliver_now
  end
end
