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
    update! claimed_at: DateTime.now
  end

  def claimed?
    self.claimed_at.present?
  end

  def auth_code?(cleartext)
    auth_code == BCrypt::Password.create(cleartext)
  end

  private

  def send_email
    auth_code = SecureRandom.base58
    update! auth_code_digest: BCrypt::Password.create(auth_code)

    if transfers.any?
      UserMailer.invitation_with_transfers(id, auth_code).deliver_now
    else
      UserMailer.invitation(id, auth_code).deliver_now
    end
  end

  def assign_transfers
    self.transfers.find_each do |t|
      t.destination ||= self.user
      t.save
    end
  end
end
