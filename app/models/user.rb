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
#  deleted_at          :datetime
#
# Indexes
#
#  index_users_on_deleted_at      (deleted_at)
#  index_users_on_parent_user_id  (parent_user_id)
#  index_users_on_type            (type)
#

class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  include Users::SettingsDecorator
  include Users::EmailPrefsDecorator
  include Users::NotificationsDecorator

  has_many :characters, dependent: :destroy
  has_many :character_groups, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :roles, through: :permissions
  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify
  has_many :sessions, class_name: 'UserSession', dependent: :destroy

  has_many :transfers_in, class_name: "Transfer", foreign_key: :destination_user_id, dependent: :destroy
  has_many :transfers_out, class_name: "Transfer", foreign_key: :sender_user_id, dependent: :destroy
  has_many :orders
  has_many :bank_accounts, inverse_of: :user, dependent: :destroy
  has_one :seller, inverse_of: :user, dependent: :destroy

  has_many :favorites, class_name: "Media::Favorite", dependent: :destroy
  has_many :favorite_media, through: :favorites, source: :media
  has_many :comments, class_name: "Media::Comment", dependent: :nullify
  has_many :notifications, dependent: :delete_all

  has_many :followers, class_name: "User::Follower", inverse_of: :following, foreign_key: :following_id, dependent: :destroy
  has_many :following, class_name: "User::Follower", inverse_of: :follower, foreign_key: :follower_id, dependent: :destroy
  has_many :follower_users, through: :following, source: :follower, class_name: "User"
  has_many :followed_users, through: :following, source: :following, class_name: "User"
  has_many :blocked_users

  has_one  :patron, class_name: "Patreon::Patron", dependent: :nullify
  has_one  :invitation, dependent: :destroy
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
  acts_as_paranoid

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

  has_markdown_field :profile

  before_validation :downcase_email
  before_update :handle_email_change
  after_update :send_email_change_notice, unless: -> (u) { u.skip_emails }
  after_create :send_welcome_email, unless: -> (u) { u.skip_emails }

  scoped_search on: [:name, :username, :email]

  scope :confirmed, -> { where.not email_confirmed_at: nil }
  scope :patrons, -> { joins(:patron).order('patreon_patrons.created_at DESC').where.not patreon_patrons: { id: nil } }
  scope :with_role, -> (r) { joins(:roles).where(roles: { name: [r, Role::ADMIN] }) }

  #== TODO THINGS

  def characters_count
    characters.count
  end


  #== Other Stuff

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

  def profile_image_url
    self.avatar? ? self.avatar.url(:small_square) : GravatarImageTag.gravatar_url(self.email, size: 200)
  end


  #== Following

  def follow!(other_user)
    self.following << User::Follower.new(following: other_user)
  end

  def unfollow!(other_user)
    User::Follower.where(follower: self, following: other_user).destroy_all
  end

  def following?(other_user)
    self.following.exists? following: other_user
  end

  def followed_by?(other_user)
    self.followers.exists? follower: other_user
  end

  def blocked?(user)
    self.blocked_users.exists?(blocked_user: user)
  end

  def block!(user)
    self.blocked_users.create(blocked_user: user)

    if followed_by? user
      self.followers.where(follower: user).destroy_all
    end
  end

  def unblock!(user)
    self.blocked_users.where(blocked_user: user).delete_all
  end


  #== Lookups

  def self.lookup(username)
    return lookup_list(username) if username.is_a? Array
    column = username =~ /@/ ? 'email' : 'username'
    find_by("LOWER(users.#{column}) = ?", username&.downcase)
  end

  def self.lookup!(username)
    column = username =~ /@/ ? 'email' : 'username'
    find_by!("LOWER(users.#{column}) = ?", username&.downcase)
  end

  def self.lookup_list(usernames)
    usernames = usernames.collect { |u| u.to_s.downcase }
    column = usernames.any? { |u| u =~ /@/ } ? 'email' : 'username'
    where("LOWER(users.#{column}) IN (?)", usernames)
  end


  #== Status Checks

  def role?(role)
    self.roles.exists?(name: role.to_s)
  end

  def admin?
    self.role_ids.include? Role.id_for Role::ADMIN
  end

  def patron?
    self.admin? or self.pledges.active.any?
  end

  # TODO - migrate
  def support_pledge_amount
    0
  end

  def supporter_level
    SupporterLevel.new(self.support_pledge_amount, admin?)
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

  def generate_auth_code!(number=false)
    auth_code = if number
                  ("%06d" % SecureRandom.random_number(1e6))
                else
                  SecureRandom.base58
                end

    update_columns auth_code_digest: BCrypt::Password.create(auth_code)
    auth_code
  end

  def send_welcome_email
    UserMailer.welcome(id, generate_auth_code!).deliver_now
  end

  class SupporterLevel
    APPRENTICE = 1
    SILVER = 5
    GOLD = 10

    def initialize(amount, admin)
      if admin
        @amount = 999
      else
        @amount = amount
      end
    end

    def authorize!(level)
      unless @amount >= level
        raise NotAuthorizedError, "Your account does not meet the supporter requirement for this feature."
      end
    end

    def apprentice?
      @amount >= APPRENTICE
    end

    def silver?
      @amount >= SILVER
    end

    def gold?
      @amount >= GOLD
    end

    class NotAuthorizedError < StandardError; end
  end

  private

  def downcase_email
    self.email&.downcase!
  end

  def handle_email_change
    if !@permit_email_swap and changes.include? :email and changes[:email][0].present?
      return if changes[:email][0].downcase == changes[:email][1].downcase
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
