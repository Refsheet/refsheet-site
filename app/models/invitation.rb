# == Schema Information
#
# Table name: invitations
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  email            :string
#  seen_at          :datetime
#  claimed_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auth_code_digest :string
#

class Invitation < ApplicationRecord
  belongs_to :user
  has_many :transfers, autosave: true

  attr_accessor :skip_emails

  validates_presence_of :user, if: -> (i) { i.claimed? }

  after_create :send_email, unless: -> (i) { i.skip_emails }
  after_save :assign_transfers, if: -> (i) { i.claimed? }

  def claim!
    update! claimed_at: DateTime.now
  end

  def claimed?
    self.claimed_at.present?
  end

  def auth_code?(cleartext)
    return false unless auth_code_digest.present?
    BCrypt::Password.new(auth_code_digest) == cleartext
  end

  def generate_auth_code!
    auth_code = SecureRandom.base58
    update! auth_code_digest: BCrypt::Password.create(auth_code)
    auth_code
  end

  private

  def send_email
    auth_code = generate_auth_code!

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
