# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  username              :string
#  email                 :string
#  password_digest       :string
#  profile               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  avatar_file_name      :string
#  avatar_content_type   :string
#  avatar_file_size      :bigint
#  avatar_updated_at     :datetime
#  settings              :json
#  type                  :string
#  auth_code_digest      :string
#  parent_user_id        :integer
#  unconfirmed_email     :string
#  email_confirmed_at    :datetime
#  deleted_at            :datetime
#  avatar_processing     :boolean
#  support_pledge_amount :integer          default(0)
#  guid                  :string
#  admin                 :boolean
#  patron                :boolean
#  supporter             :boolean
#  moderator             :boolean
#
# Indexes
#
#  index_users_on_deleted_at               (deleted_at)
#  index_users_on_guid                     (guid)
#  index_users_on_lower_email              (lower((email)::text) varchar_pattern_ops)
#  index_users_on_lower_unconfirmed_email  (lower((unconfirmed_email)::text) varchar_pattern_ops)
#  index_users_on_lower_username           (lower((username)::text) varchar_pattern_ops)
#  index_users_on_parent_user_id           (parent_user_id)
#  index_users_on_type                     (type)
#

class User < ApplicationRecord
  include HasGuid

  include Rails.application.routes.url_helpers

  include Users::SettingsDecorator
  include Users::EmailPrefsDecorator
  include Users::NotificationsDecorator
  include Users::RoleDecorator

  include HasImageAttached

  has_many :characters, dependent: :destroy
  has_many :character_groups, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :roles, through: :permissions
  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify
  has_many :sessions, class_name: 'UserSession', dependent: :destroy
  has_many :api_keys, dependent: :destroy

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

  has_one  :patreon_patron, class_name: "Patreon::Patron", dependent: :nullify
  has_one  :invitation, dependent: :destroy
  has_many :pledges, through: :patreon_patron

  attr_accessor :skip_emails

  validates :username, presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-z0-9][a-z0-9_]+[a-z0-9]\z/i, message: 'no special characters' },
            exclusion: { in: RouteRecognizer.instance.initial_path_segments, message: 'is reserved' },
            uniqueness: { case_sensitive: false, conditions: -> { with_deleted } }

  validates :email, presence: true,
            format: { with: /@/, message: 'must have @ sign' },
            uniqueness: { case_sensitive: false, conditions: -> { with_deleted } }

  has_secure_password
  acts_as_paranoid
  has_guid

  has_image_attached :as_avatar,
                     default_url: -> (u, _style) {
                       ActionController::Base.helpers.image_url('default.png')
                       # TODO: Make Gravatar an opt-in on user settings to prevent fake scares about suspicious
                       #       "leaks" of account data and whatnot.
                       # GravatarImageTag.gravatar_url(u.email, size: 480)
                     },
                     styles: {
                         thumbnail: { fill: [64, 64] },
                         small_square: { fill: [480, 480] },
                         small: { fit: [480, 480] },
                         medium_square: { fill: [720, 720] },
                         medium: { fit: [720, 720] }
                     }

  has_attached_file :avatar,
                    default_url: -> (_u) {
                      ActionController::Base.helpers.image_url('default.png')
                      # TODO: Make Gravatar an opt-in on user settings to prevent fake scares about suspicious
                      #       "leaks" of account data and whatnot.
                      # GravatarImageTag.gravatar_url(u.email, size: 480)
                    },
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

  process_in_background :avatar,
                        processing_image_url: -> (attachment) {
                          ActionController::Base.helpers.image_path("placeholders/processing_500.png")
                        }

  has_markdown_field :profile

  before_validation :downcase_email
  before_validation :adjust_role_flags
  before_update :handle_email_change
  after_update :send_email_change_notice, unless: -> (u) { u.skip_emails }
  after_create :send_welcome_email, unless: -> (u) { u.skip_emails }

  scoped_search on: [:name, :username, :email]

  scope :confirmed, -> { where.not email_confirmed_at: nil }

  #== TODO THINGS

  def characters_count
    characters.count
  end


  #== Other Stuff

  def name
    super || username
  end

  def email_to(email=self.email)
    "\"#{name}\" <#{email}>"
  end

  def to_param
    username
  end

  def avatar_url(style = :thumbnail)
    if self.as_avatar.attached?
      self.as_avatar.url(style)
    else
      self.avatar.url(style)
    end
  end

  def profile_image_url
    self.avatar_url(:small_square)
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

  def blocked_by?(user)
    user.blocked? self
  end

  def block!(user)
    if user.admin?
      raise "You cannot block an admin."
    end

    self.blocked_users.create(blocked_user: user)
    self.followers.where(follower: user).destroy_all
    self.following.where(following: user).destroy_all
  end

  def unblock!(user)
    self.blocked_users.where(blocked_user: user).delete_all
  end


  #== Lookups

  def self.lookup(username, allow_email = true)
    return nil if username.nil?
    return lookup_list(username) if username.is_a? Array
    column = username =~ /@/ && allow_email ? 'email' : 'username'
    find_by("LOWER(users.#{column}) = ?", username&.downcase)
  end

  def self.lookup!(username, allow_email = true)
    return nil if username.nil?
    column = username =~ /@/ && allow_email ? 'email' : 'username'
    find_by!("LOWER(users.#{column}) = ?", username&.downcase)
  end

  def self.lookup_list(usernames, allow_email = true)
    usernames = usernames.collect { |u| u.to_s.downcase }
    column = allow_email && usernames.any? { |u| u =~ /@/ } ? 'email' : 'username'
    where("LOWER(users.#{column}) IN (?)", usernames)
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

  def adjust_role_flags
    # HOLIDAY - April 1
    if DateTime.now.in_time_zone("Central Time (US & Canada)").to_date == Date.new(2021, 04, 01)
      if self.profile =~ /\buwu\b/i
        self.support_pledge_amount = 41
        self.supporter = true
      end
    end

    if self.support_pledge_amount_changed?
      self.supporter = self.support_pledge_amount > 0
    end
  end
end
