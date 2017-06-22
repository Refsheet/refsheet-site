# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  username            :string
#  email               :string
#  password_digest     :string
#  profile             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  settings            :json
#  type                :string
#  auth_code_digest    :string
#  parent_user_id      :integer
#  unconfirmed_email   :string
#  email_confirmed_at  :datetime
#

class User < ApplicationRecord
  has_many :characters
  has_many :character_groups
  has_many :transfers_in, class_name: Transfer, foreign_key: :destination_user_id
  has_many :transfers_out, class_name: Transfer, foreign_key: :sender_user_id
  has_many :permissions
  has_many :roles, through: :permissions
  has_many :visits
  has_many :favorites, class_name: Media::Favorite
  has_many :comments, class_name: Media::Comment
  has_one  :patron, class_name: Patreon::Patron
  has_one  :invitation
  has_many :pledges, through: :patron

  attr_accessor :skip_emails

  validates :username, presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-z0-9][a-z0-9_]+[a-z0-9]\z/i, message: 'no special characters' },
            exclusion: { in: RouteRecognizer.instance.initial_path_segments, message: 'is reserved' },
            uniqueness: { case_sensitive: false }

  validates :email, presence: true,
            format: { with: /@/, message: 'must have @ sign' },
            uniqueness: { case_sensitive: false }

  has_secure_password

  has_attached_file :avatar,
                    styles: {
                        thumbnail: '64x64#',
                        small_square: '427x427#',
                        small: '427x>',
                        medium_square: '854x854#',
                        medium: '854x>'
                    },
                    s3_permissions: {
                        original: :private
                    }

  validates_attachment :avatar,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..25.megabytes }

  serialize :settings, JSON

  before_validation :downcase_email
  before_update :handle_email_change
  after_update :send_email_change_notice, unless: -> (u) { u.skip_emails }
  after_create :send_welcome_email, unless: -> (u) { u.skip_emails }

  scoped_search on: [:name, :username, :email]

  scope :confirmed, -> { where.not email_confirmed_at: nil }

  def name
    super || username
  end

  def email_to(email=self.email)
    "#{name} <#{email}>"
  end

  def to_param
    username
  end

  def avatar_url
    self.avatar? ? self.avatar.url(:thumbnail) : GravatarImageTag.gravatar_url(self.email)
  end

  def settings
    HashWithIndifferentAccess.new(super || {})
  end

  def profile_image_url
    self.avatar? ? self.avatar.url(:small_square) : GravatarImageTag.gravatar_url(self.email, size: 200)
  end

  def self.lookup(username)
    column = username =~ /@/ ? 'email' : 'username'
    find_by("LOWER(users.#{column}) = ?", username.downcase)
  end

  def self.lookup!(username)
    column = username =~ /@/ ? 'email' : 'username'
    find_by!("LOWER(users.#{column}) = ?", username.downcase)
  end

  def role?(role)
    self.roles.exists?(name: role.to_s)
  end

  #== Email Confirmation & Password Reset

  def confirmed?
    email_confirmed_at.present?
  end

  def confirm!
    @permit_email_swap = true
    email = self.unconfirmed_email || self.email
    update! email_confirmed_at: Time.zone.now, email: email, auth_code_digest: nil, unconfirmed_email: nil
    @permit_email_swap = false
    claim_invitations
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

  def send_welcome_email
    UserMailer.welcome(id, generate_auth_code!).deliver_now
  end

  private

  def downcase_email
    self.email&.downcase!
  end

  def handle_email_change
    if !@permit_email_swap and changes.include? :email and changes[:email][0].present?
      self.unconfirmed_email = self.changes[:email][1]
      self.email = self.changes[:email][0]
      @send_email_change_notice = true
    end
  end

  def send_email_change_notice
    if @send_email_change_notice
      @send_email_change_notice = false
      UserMailer.email_changed(id, generate_auth_code!).deliver_now
    end
  end

  def claim_invitations
    if (invitation = Invitation.find_by('LOWER(invitations.email) = ?', self.email))
      invitation.user = self
      invitation.claim!
      self.invitation = invitation
    end
  end
end
