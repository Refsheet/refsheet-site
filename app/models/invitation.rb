# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  email      :string
#  seen_at    :datetime
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Invitation < ApplicationRecord
  belongs_to :user
  has_many :transfers, autosave: true

  validates_presence_of :user, if: -> (i) { i.claimed? }

  after_create :send_email
  after_save :assign_transfers, if: -> (i) { i.claimed? }

  def claim!
    self.claimed_at = DateTime.now
    self.save
  end

  def claimed?
    self.claimed_at.present?
  end

  private

  def send_email
    # TODO Send Email
  end

  def assign_transfers
    self.transfers.find_each do |t|
      t.destination ||= self.user
      t.save
    end
  end
end
