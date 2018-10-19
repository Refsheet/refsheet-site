# == Schema Information
#
# Table name: patreon_patrons
#
#  id               :integer          not null, primary key
#  patreon_id       :string
#  email            :string
#  full_name        :string
#  image_url        :string
#  is_deleted       :boolean
#  is_nuked         :boolean
#  is_suspended     :boolean
#  status           :string
#  thumb_url        :string
#  twitch           :string
#  twitter          :string
#  youtube          :string
#  vanity           :string
#  url              :string
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auth_code_digest :string
#  pending_user_id  :integer
#

class Patreon::Patron < ApplicationRecord
  has_many :pledges, class_name: "Patreon::Pledge", foreign_key: :patreon_patron_id
  has_many :rewards, through: :pledges
  belongs_to :user

  before_validation :match_user

  def email_to(email=self.email)
    "#{full_name} <#{email}>"
  end

  def generate_auth_code!(number=false)
    auth_code = if number
                  ("%06d" % SecureRandom.random_number(1e6))
                else
                  SecureRandom.base58
                end

    update_columns auth_code_digest: BCrypt::Password.create(auth_code)
    auth_code
  end

  def auth_code?(cleartext)
    return false unless auth_code_digest.present?
    BCrypt::Password.new(auth_code_digest) == cleartext
  end

  def initiate_link!(user)
    update_columns pending_user_id: user.id
    UserMailer.patron_link(self, generate_auth_code!).deliver_now
  end

  def match_user
    self.user ||= User.find_by('LOWER(users.email) = ?', self.email&.downcase)
  end

  def match_user!
    self.match_user
    self.save!
  end
end
